import { HttpException, Injectable } from "@nestjs/common";

import { CodeGeneratorService } from "src/code-generator/code-generator.service";
import { CreateSalaryDto } from "./dto/create-salary.dto";
import { DatabaseService } from "src/database/database.service";
import { FirebaseService } from "src/firebase/firebase.service";
import { PayrollPdfService } from "./payroll-pdf.service";
import { ReportPayrollDto } from "./dto/reportPayroll-salary.dto";
import { UpdateSalaryDto } from "./dto/update-salary.dto";
import dayjs from "dayjs";
import path from "node:path";

@Injectable()
export class SalaryService {
  constructor(
    private readonly prisma: DatabaseService,
    private readonly pdfService: PayrollPdfService,
    private readonly firebaseService: FirebaseService,
    private readonly codeGen: CodeGeneratorService,
  ) {}

  async createSalaryUser(createDataSalaryUser: CreateSalaryDto) {
    try {
      const data = await this.prisma.salaryConfig.create({
        data: {
          ...createDataSalaryUser,
        },
      });
      return data;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getSalaryListUser() {
    try {
      const data = await this.prisma.salaryConfig.findMany({
        select: {
          baseSalary: true,
          overtimeRate: true,
          otNightRate: true,
          nightRate: true,
          lateRate: true,
          earlyRate: true,
          effectiveDate: true,
          expireDate: true,
          user: {
            select: {
              fullName: true,
              email: true,
              userCode: true,
              avatar: true,
            },
          },
          createdAt: true,
          updatedAt: true,
        },
      });

      return data;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getPayslipList(month?: string) {
    try {
      // Use current month if not provided
      const targetMonth = month ? dayjs(month) : dayjs();
      const startOfMonth = targetMonth.startOf("month").toDate();
      const endOfMonth = targetMonth.endOf("month").toDate();

      const payslips = await this.prisma.payslip.findMany({
        where: {
          createdAt: {
            gte: startOfMonth,
            lte: endOfMonth,
          },
        },
        select: {
          id: true,
          userCode: true,
          payrollCode: true,
          payslipFile: true,
          createdAt: true,
          updatedAt: true,
        },
        orderBy: {
          createdAt: "desc",
        },
      });

      // Enrich with user and payroll information
      const enrichedPayslips = await Promise.all(
        payslips.map(async (payslip) => {
          const user = await this.prisma.user.findFirst({
            where: { userCode: payslip.userCode },
            select: {
              userCode: true,
              fullName: true,
              email: true,
              avatar: true,
            },
          });

          const payroll = await this.prisma.payroll.findFirst({
            where: { payrollCode: payslip.payrollCode },
            select: {
              payrollCode: true,
              payrollName: true,
              startDate: true,
              endDate: true,
              paymentDate: true,
            },
          });

          return {
            ...payslip,
            user,
            payroll,
          };
        }),
      );

      return enrichedPayslips;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async reportPayroll(reportPayroll: ReportPayrollDto) {
    try {
      const endMonth = dayjs(reportPayroll.month).endOf("month");
      const startMonth = dayjs(reportPayroll.month).startOf("month");
      const listUser = await this.prisma.user.findMany({
        select: {
          userCode: true,
        },
      });

      const result = await Promise.all(
        listUser.map(async (user) => {
          const dataTimeSheet = await this.prisma.payroll.findMany({
            where: {
              startDate: {
                lte: endMonth.toDate(),
                gte: startMonth.toDate(),
              },
              isActive: true,
            },
            select: {
              id: true,
              payrollCode: true,
              payrollName: true,
              companyCode: true,
              startDate: true,
              endDate: true,
              paymentDate: true,
              isLocked: true,
              isActive: true,
              company: {
                select: {
                  companyName: true,
                },
              },
              attendanceRecs: {
                select: {
                  id: true,
                  userCode: true,
                  workDay: true,
                  timeIn: true,
                  timeOut: true,
                  status: true,
                  lateMinutes: true,
                  earlyMinutes: true,
                },
                where: {
                  userCode: user.userCode,
                },
                orderBy: {
                  workDay: "desc",
                },
              },
            },
          });
          const salaryInfo = await this.prisma.user.findFirst({
            where: {
              userCode: user.userCode,
            },
            select: {
              userCode: true,
              fullName: true,
              email: true,
              avatar: true,
              address: true,
              phone: true,
              company: {
                select: {
                  companyName: true,
                  address: true,
                },
              },
              salaryConfigs: {
                select: {
                  baseSalary: true,
                  overtimeRate: true,
                  otNightRate: true,
                  nightRate: true,
                  lateRate: true,
                  earlyRate: true,
                  effectiveDate: true,
                  expireDate: true,
                },
              },
            },
          });

          const filePath = await this.pdfService.generatePayrollPdf(
            {
              ...salaryInfo,
              attendanceRecs: dataTimeSheet[0],
            },
            reportPayroll.month,
          );
          const payslipFilePath = path.join(
            filePath
              .split("/")
              .slice(2)
              .map((item) => item)
              .join("/"),
          );
          // inster file path to payroll
          //chek exits payslip
          const payslip = await this.prisma.payslip.findFirst({
            where: {
              userCode: user.userCode,
              payrollCode: dataTimeSheet[0].payrollCode,
            },
          });
          if (payslip) {
            await this.prisma.payslip.update({
              where: {
                id: payslip.id,
              },
              data: {
                payslipFile: payslipFilePath,
              },
            });
            return {
              ...salaryInfo,
              attendanceRecs: dataTimeSheet[0],
              filePath,
            };
          }
          await this.prisma.payslip.create({
            data: {
              userCode: user.userCode,
              payrollCode: dataTimeSheet[0].payrollCode,
              payslipFile: payslipFilePath,
            },
          });
          return {
            ...salaryInfo,
            attendanceRecs: dataTimeSheet[0],
            filePath,
          };
        }),
      );
      // create notification
      const notiCode = await this.codeGen.generateCode(
        this.prisma.notification,
        "NOT",
        {
          field: "notificationCode",
        },
      );
      await this.prisma.notification.create({
        data: {
          notificationCode: notiCode,
          title: `Payslip Report ${dayjs(reportPayroll.month).startOf("month").format("DD/MM/YYYY")} - ${dayjs(
            reportPayroll.month,
          )
            .endOf("month")
            .format("DD/MM/YYYY")}`,
          body: "Payslip is ready to download, please check your payslip and contact if you have any question",
          targetType: "ALL",
          notificationType: "PAYSLIP_REPORT",
          openSent: 1,
        },
      });
      //sent noti to user
      await this.firebaseService.sendNotificationToTopic({
        topic: "user-topic",
        title: "Payslip Report",
        body: "Payslip is ready to download, please check your payslip and contact if you have any question",
        data: {
          notificationId: notiCode,
        },
      });
      return {};
    } catch (error) {
      throw new HttpException(error, 500);
    }
  }
}
