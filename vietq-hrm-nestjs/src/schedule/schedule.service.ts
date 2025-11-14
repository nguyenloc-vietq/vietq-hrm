import { PayrollConfig } from "./../../node_modules/.prisma/client/index.d";
import { HttpException, Injectable, Req } from "@nestjs/common";
import { UpdateScheduleDto } from "./dto/update-schedule.dto";
import { DatabaseService } from "../database/database.service";
import dayjs from "dayjs";
import { CodeGeneratorService } from "src/code-generator/code-generator.service";
import { CreateScheduleDto } from "./dto/create-schedule.dto";

@Injectable()
export class ScheduleService {
  constructor(
    private readonly prisma: DatabaseService,
    private codeGen: CodeGeneratorService,
  ) {}

  async create(dataSchedule: CreateScheduleDto, @Req() req) {
    try {
      const { userCode } = req.user;

      const lastRecord = await this.prisma.employeeSchedule.findFirst({
        orderBy: { scheduleCode: "desc" },
        select: { scheduleCode: true },
      });

      const lastNumber = lastRecord?.scheduleCode
        ? parseInt(lastRecord.scheduleCode.replace("SDC", ""), 10)
        : 0;

      //Tạo mảng code mới theo số lượng workOn
      const scheduleCodes = dataSchedule.workOn.map(
        (_, idx) => `SDC${String(lastNumber + idx + 1).padStart(6, "0")}`,
      );

      const payrollCode = await this.prisma.payroll.findFirst({
        where: {
          startDate: { lte: dataSchedule.workOn[0] },
          endDate: { gte: dataSchedule.workOn[dataSchedule.workOn.length - 1] },
          isActive: true,
        },
        select: { payrollCode: true },
      });
      //huẩn bị dữ liệu insert
      const newSchedule = dataSchedule.workOn.map((workOnDate, idx) => ({
        ...dataSchedule,
        scheduleCode: scheduleCodes[idx],
        userCode,
        payrollCode: payrollCode?.payrollCode,
        workOn: new Date(workOnDate),
      }));

      const result = await this.prisma.employeeSchedule.createMany({
        data: newSchedule,
      });
      return { dataSchedule: [...newSchedule] };
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
    const today = req.query.today;
    console.log(today);
    const startOfMonth = dayjs().startOf("month").toDate();

    const endOfMonth = dayjs().endOf("month").toDate();

    try {
      const payrollData = await this.prisma.payrollConfig.findFirst({
        where: {
          companyCode: req.user.companyCode,
        },
        select: { totalDay: true },
      });
      const totalWokingDay = await this.prisma.attendanceRecord.count({
        where: {
          userCode: req.user.userCode,
          status: "PRESENT",
        },
      });
      const schedules = await this.prisma.employeeSchedule.findMany({
        where: {
          scheduleCode: scheduleCode,
          workOn: {
            gte: today ? dayjs(today).startOf("day").toDate() : startOfMonth,
            lte: today ? dayjs(today).endOf("day").toDate() : endOfMonth,
          },
          userCode: req.user.userCode,
          isActive: "Y",
        },
        include: {
          shift: {
            select: {
              shiftCode: true,
              name: true,
              startTime: true,
              endTime: true,
            },
          },
        },
      });
      const result = schedules.map((item) => ({
        ...item,
        ...payrollData,
        totalWokingDay,
      }));

      return [...result];
    } catch (e) {
      throw new HttpException("Get schedules failed", 500);
    }
  }

  async update(dataSchedule: UpdateScheduleDto) {
    try {
      const payrollCode = await this.prisma.payroll.findFirst({
        where: {
          startDate: { lte: dataSchedule.workOn[0] },
          endDate: { gte: dataSchedule.workOn[dataSchedule.workOn.length - 1] },
          isActive: true,
        },
        select: { payrollCode: true },
      });

      const result = await Promise.all(
        dataSchedule.workOn.map(async (workOnDate, idx) => {
          console.log(
            `[===============> daat | ${dataSchedule.scheduleCode[idx]}`,
          );
          await this.prisma.employeeSchedule.update({
            where: {
              scheduleCode: dataSchedule.scheduleCode[idx],
            },
            data: {
              workOn: new Date(workOnDate),
              payrollCode: payrollCode?.payrollCode,
              shiftCode: dataSchedule.shiftCode,
            },
          });
        }),
      );
      return { scheduleUpdate: [...result] };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
  async delete(scheduleCode: string) {
    try {
      await this.prisma.employeeSchedule.delete({
        where: {
          scheduleCode,
        },
      });
      return [];
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
