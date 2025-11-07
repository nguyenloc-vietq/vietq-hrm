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

@Injectable()
export class ScheduleService {
  constructor(private readonly prisma: DatabaseService) {}

  async create(dataSchedule: CreateScheduleDto, @Req() req) {
    try {
      const { id } = req.user;
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
          scheduleCode: dataSchedule.scheduleCode,
          workOn: dataSchedule.workOn,
          userId: id,
          payrollCode: payrollCode?.payrollCode,
          shiftId: dataSchedule.shiftId,
        },
      });
      return { ...newSchedule };
    } catch (e) {
      throw new HttpException("Create schedule failed", 500);
    }
  }
}
