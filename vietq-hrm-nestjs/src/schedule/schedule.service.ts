import {
  BadRequestException,
  HttpException,
  Injectable,
  Req,
} from "@nestjs/common";
import { CreateScheduleDto } from "./dto/create-schedule.dto";
import { UpdateScheduleDto } from "./dto/update-schedule.dto";
import { DatabaseService } from "../database/database.service";
import { ResponseDataSuccess } from "../global/globalClass";
import dayjs from "dayjs";

@Injectable()
export class ScheduleService {
  constructor(private readonly prisma: DatabaseService) {}

  async create(dataSchedule: CreateScheduleDto, @Req() req) {
    try {
      const { userCode } = req.user;
      const payrollCode = await this.prisma.payroll.findFirst({
        where: {
          startDate: { lte: dataSchedule.workOn },
          endDate: { gte: dataSchedule.workOn },
          isActive: true,
          // companyId: req.user.companyId,
        },
        select: {
          payrollCode: true,
        },
      });
      const newSchedule = await this.prisma.employeeSchedule.create({
        data: {
          ...dataSchedule,
          userCode,
          payrollCode: payrollCode?.payrollCode,
        },
      });
      return { ...newSchedule };
    } catch (e) {
      throw new HttpException("Create schedule failed", 500);
    }
  }
  async getSchedulesInMonth(@Req() req) {
    const startOfMonth = dayjs().startOf("month");
    const endOfMonth = dayjs().endOf("month");
    try {
      const schedules = await this.prisma.employeeSchedule.findMany({
        where: {
          userCode: req.user.userCode,
          isActive: "Y",
          workOn: {
            gte: startOfMonth.toDate(),
            lte: endOfMonth.toDate(),
          },
        },
        include: {
          shift: {
            select: {
              startTime: true,
              endTime: true,
            },
          },
        },
      });
      return [...schedules];
    } catch (e) {
      throw new HttpException("Get schedules failed", 500);
    }
  }
  async getSchedulesInDay(@Req() req) {
    const scheduleCode = req.query.scheduleCode;
    try {
      const schedules = await this.prisma.employeeSchedule.findMany({
        where: {
          scheduleCode: scheduleCode,
          userCode: req.user.userCode,
          isActive: "Y",
        },
        include: {
          shift: {
            select: {
              startTime: true,
              endTime: true,
            },
          },
        },
      });
      return [...schedules];
    } catch (e) {
      throw new HttpException("Get schedules failed", 500);
    }
  }
}
