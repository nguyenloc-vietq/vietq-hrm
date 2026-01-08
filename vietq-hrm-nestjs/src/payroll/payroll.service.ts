import { HttpException, Injectable } from "@nestjs/common";
import { GetPayrollDto } from "./dto/getPayroll-payroll.dto";
import dayjs from "dayjs";
import { DatabaseService } from "src/database/database.service";
import express from "express";
import {
  UpdatePayrollConfigDto,
  UpdatePayrollDto,
} from "./dto/update-payroll.dto";
import { CreatePayrollDto } from "./dto/create-payroll.dto";
import { CodeGeneratorService } from "src/code-generator/code-generator.service";

@Injectable()
export class PayrollService {
  constructor(
    private readonly prisma: DatabaseService,
    private readonly codeGen: CodeGeneratorService,
  ) {}

  async getPayroll(req: express.Request): Promise<object> {
    try {
      const { year, all } = req.query;
      const startOfYear =
        dayjs(year as string).startOf("year") ?? dayjs().startOf("year");
      const endOfYear =
        dayjs(year as string).endOf("year") ?? dayjs().endOf("year");
      return await this.prisma.payroll.findMany({
        where: {
          startDate: {
            gte: all ? undefined : startOfYear.toDate(),
            lte: all ? undefined : endOfYear.toDate(),
          },
        },
        orderBy: {
          startDate: "desc",
        },
      });
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async updatePayroll(dataUpdate: UpdatePayrollDto) {
    try {
      const { payrollCode, ...data } = dataUpdate;
      await this.prisma.payroll.update({
        where: { payrollCode },
        data: {
          ...data,
        },
      });
      return {};
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async createPayroll(dataCreate: CreatePayrollDto, req) {
    try {
      const prefix = "PRC";
      const { companyCode } = req.user;
      const lastRecord = await this.prisma.payroll.findFirst({
        orderBy: { payrollCode: "desc" },
        select: { payrollCode: true },
      });

      const lastNumber = lastRecord?.payrollCode
        ? parseInt(lastRecord.payrollCode.replace(prefix, ""), 10)
        : 0;

      //Tạo mảng code mới theo số lượng workOn
      const payroll = await this.prisma.payroll.createMany({
        data: dataCreate.listCreatePayroll.map((item, idx) => ({
          payrollCode: `${prefix}${String(lastNumber + idx + 1).padStart(6, "0")}`,
          payrollName: `Payroll ${dayjs(item.startDate).format("YYYY-MM-DD")}`,
          companyCode,
          ...item,
        })),
      });
      return payroll;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
  async getPayrollConfig(req) {
    try {
      const { companyCode } = req.user;
      const config = await this.prisma.payrollConfig.findFirst({
        where: { companyCode: companyCode },
      });
      return { ...config };
    } catch (error) {
      return new HttpException(error.message, 500);
    }
  }

  async updatePayrollConfig(dataUpdate: UpdatePayrollConfigDto, req) {
    try {
      const { companyCode } = req.user;
      await this.prisma.payrollConfig.update({
        where: {
          companyCode,
        },
        data: {
          ...dataUpdate,
        },
      });

      return {};
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
  async getListUserPayroll(req) {
    try {
      const { userCode } = req.user;
      const listPayslips = await this.prisma.payslip.findMany({
        where: {
          userCode,
        },
        orderBy: {
          createdAt: "desc",
        },
      });
      const result = await Promise.all(
        listPayslips.map(async (p) => {
          const payroll = await this.prisma.payroll.findUnique({
            where: { payrollCode: p.payrollCode },
          });
          return {
            ...p,
            payroll,
          };
        }),
      );
      result.sort((a, b) => {
        const aTime = a.payroll?.startDate?.getTime() ?? Infinity;
        const bTime = b.payroll?.startDate?.getTime() ?? Infinity;
        return bTime - aTime;
      });

      return result;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getAdminListPayslips() {
    try {
      const listPayslips = await this.prisma.payslip.findMany({
        orderBy: {
          createdAt: "desc",
        },
      });
      const result = await Promise.all(
        listPayslips.map(async (p) => {
          const payroll = await this.prisma.payroll.findUnique({
            where: { payrollCode: p.payrollCode },
          });
          return {
            ...p,
            payroll,
          };
        }),
      );

      return result;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
