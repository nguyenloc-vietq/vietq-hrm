import { HttpException, Injectable } from "@nestjs/common";
import { RegistrationStatus } from "@prisma/client";
import { CodeGeneratorService } from "src/code-generator/code-generator.service";
import { DatabaseService } from "src/database/database.service";
import { CreateRegistrationDto } from "./dto/create-registration.dto";

@Injectable()
export class RegistrationService {
  constructor(
    private readonly prisma: DatabaseService,
    private readonly codeGen: CodeGeneratorService,
  ) {}

  async listApplications(req) {
    try {
      const { status } = req.query;
      const { userCode } = req.user;

      // 1. Lấy danh sách đơn đăng ký
      const registrations = await this.prisma.registrationForm.findMany({
        where: {
          userCode: userCode,
          isActive: true,
          status: status || undefined,
        },
        orderBy: { createdAt: "desc" },
      });

      // 2. Lấy cấu hình lương để xem tổng ngày phép (AnnualLeave)
      const salaryConfig = await this.prisma.salaryConfig.findFirst({
        where: { userCode: userCode },
        select: { AnnualLeave: true },
      });

      const stats = await this.prisma.registrationForm.groupBy({
        by: ["status"],
        where: {
          userCode: userCode,
          isActive: true,
        },
        _count: {
          status: true,
        },
      });

      const summary = {
        annualLeave: salaryConfig?.AnnualLeave || 12,
        approved:
          stats.find((s) => s.status === "APPROVED")?._count.status || 0,
        pending: stats.find((s) => s.status === "PENDING")?._count.status || 0,
        rejected:
          stats.find((s) => s.status === "REJECTED")?._count.status || 0,
      };

      return {
        items: registrations,
        summary: summary,
      };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async listApprovals(req) {
    try {
      const { userCode } = req.user;
      const data = await this.prisma.registrationForm.findMany({
        where: {
          isActive: true,
          status: "PENDING",
        },
        include: {
          user: {
            select: {
              fullName: true,
              email: true,
              phone: true,
            },
          },
        },
      });
      const salaryConfig = await this.prisma.salaryConfig.findFirst({
        where: { userCode: userCode },
        select: { AnnualLeave: true },
      });
      const stats = await this.prisma.registrationForm.groupBy({
        by: ["status"],
        where: {
          userCode: userCode,
          isActive: true,
        },
        _count: {
          status: true,
        },
      });
      const summary = {
        annualLeave: salaryConfig?.AnnualLeave || 12,
        approved:
          stats.find((s) => s.status === "APPROVED")?._count.status || 0,
        pending: stats.find((s) => s.status === "PENDING")?._count.status || 0,
        rejected:
          stats.find((s) => s.status === "REJECTED")?._count.status || 0,
      };
      return {
        items: data,
        summary: summary,
      };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async listHistoryApprovals(req) {
    try {
      const data = await this.prisma.registrationApproval.findMany({
        select: {
          userApproverCode: true,
          newStatus: true,
          registrationCode: true,
          prevStatus: true,
          registrationForm: {
            select: {
              userCode: true,
              startDate: true,
              endDate: true,
              reason: true,
              type: true,
              timeIn: true,
              timeOut: true,
            },
          },
        },
      });
      return data;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async approveRegistration(req, approveRegistration) {
    try {
      const { userCode } = req.user;
      const { registrationCode, status } = approveRegistration;

      //check regis exits
      const registration = await this.prisma.registrationForm.findUnique({
        where: {
          registrationCode: registrationCode,
        },
        select: {
          status: true,
        },
      });
      if (!registration) {
        throw new HttpException("Registration not found", 404);
      }
      if (registration.status === RegistrationStatus.APPROVED) {
        throw new HttpException("Registration is already approved", 400);
      }
      await this.prisma.registrationForm.update({
        where: {
          registrationCode: registrationCode,
        },
        data: {
          status: status,
        },
      });
      //check exit
      const approval = await this.prisma.registrationApproval.findFirst({
        where: {
          registrationCode: registrationCode,
        },
      });
      if (approval) {
        const dataApprove = await this.prisma.registrationApproval.updateMany({
          where: {
            registrationCode: registrationCode,
          },
          data: {
            userApproverCode: userCode,
            prevStatus: registration.status,
            newStatus: status,
          },
        });

        return dataApprove;
      }
      const dataApprove = await this.prisma.registrationApproval.create({
        data: {
          userApproverCode: userCode,
          registrationCode: registrationCode,
          prevStatus: registration.status,
          newStatus: status,
        },
      });

      return dataApprove;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async rejectRegistration(req, rejectRegistration) {
    try {
      const { userCode } = req.user;
      const { registrationCode, status } = rejectRegistration;

      //check regis exits
      const registration = await this.prisma.registrationForm.findUnique({
        where: {
          registrationCode: registrationCode,
        },
        select: {
          status: true,
        },
      });
      if (!registration) {
        throw new HttpException("Registration not found", 404);
      }
      if (registration.status === RegistrationStatus.REJECTED) {
        throw new HttpException(
          "Registration is already rejected or approved",
          400,
        );
      }
      await this.prisma.registrationForm.update({
        where: {
          registrationCode: registrationCode,
        },
        data: {
          status: status,
        },
      });
      const rejectData = await this.prisma.registrationApproval.findFirst({
        where: {
          registrationCode: registrationCode,
        },
      });
      if (rejectData) {
        const dataReject = await this.prisma.registrationApproval.updateMany({
          where: {
            registrationCode: registrationCode,
          },
          data: {
            userApproverCode: userCode,
            prevStatus: registration.status,
            newStatus: status,
          },
        });
        return dataReject;
      }
      const dataReject = await this.prisma.registrationApproval.create({
        data: {
          userApproverCode: userCode,
          registrationCode: registrationCode,
          prevStatus: registration.status,
          newStatus: status,
        },
      });
      return dataReject;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async createRegistration(req, createRegistration: CreateRegistrationDto) {
    try {
      const { userCode } = req.user;
      const registrationCode = await this.codeGen.generateCode(
        this.prisma.registrationForm,
        "RGC",
        {
          field: "registrationCode",
        },
      );
      //check regis exits
      const registration = await this.prisma.registrationForm.create({
        data: {
          userCode: userCode,
          registrationCode: registrationCode,
          ...createRegistration,
        },
      });

      return registration;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
