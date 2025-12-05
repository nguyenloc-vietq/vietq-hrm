import { HttpException, Injectable } from "@nestjs/common";

import { CreateSalaryDto } from "./dto/create-salary.dto";
import { DatabaseService } from "src/database/database.service";
import { PayrollPdfService } from "./payroll-pdf.service";
import { ReportPayrollDto } from "./dto/reportPayroll-salary.dto";
import { UpdateSalaryDto } from "./dto/update-salary.dto";
import dayjs from "dayjs";

@Injectable()
export class SalaryService {
  constructor(
    private readonly prisma: DatabaseService,
    private readonly pdfService: PayrollPdfService,
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

  async reportPayroll(reportPayroll: ReportPayrollDto) {
    try {
      const endMonth = dayjs(reportPayroll.month).endOf("month");
      const startMonth = dayjs(reportPayroll.month).startOf("month");
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
              userCode: reportPayroll.userCode,
            },
            orderBy: {
              workDay: "desc",
            },
          },
        },
      });
      const salaryInfo = await this.prisma.user.findFirst({
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
      const filePath = await this.pdfService.generatePayrollPdf({
        ...salaryInfo,
        attendanceRecs: dataTimeSheet[0],
      });
      console.log(filePath);
      return {
        ...salaryInfo,
        attendanceRecs: dataTimeSheet[0],
      };
    } catch (error) {
      throw new HttpException(error, 500);
    }
  }
}
