/* eslint-disable @typescript-eslint/no-explicit-any */
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

  async create(dataSchedule: CreateScheduleDto, req?: any) {
    try {
      const { userCode, action } = dataSchedule;

      // Nếu action = "all", lấy tất cả user active trong company
      let userCodes: string[] = [];
      if (action === "all") {
        if (!req || !req.user || !req.user.companyCode) {
          throw new HttpException("Company code is required", 400);
        }
        const users = await this.prisma.user.findMany({
          where: {
            companyCode: req.user.companyCode,
            isActive: "Y",
          },
          select: { userCode: true },
        });
        userCodes = users.map((user) => user.userCode);
      } else {
        if (!userCode) {
          throw new HttpException("User code is required", 400);
        }
        userCodes = [userCode];
      }

      const lastRecord = await this.prisma.employeeSchedule.findFirst({
        orderBy: { scheduleCode: "desc" },
        select: { scheduleCode: true },
      });

      const lastNumber = lastRecord?.scheduleCode
        ? parseInt(lastRecord.scheduleCode.replace("SDC", ""), 10)
        : 0;

      const payrollCode = await this.prisma.payroll.findFirst({
        where: {
          startDate: { lte: dataSchedule.workOn[0] },
          endDate: { gte: dataSchedule.workOn[dataSchedule.workOn.length - 1] },
          isActive: true,
        },
        select: { payrollCode: true },
      });

      // Tạo schedule cho tất cả user
      let codeCounter = lastNumber;
      const allSchedules: Array<{
        scheduleCode: string;
        userCode: string;
        shiftCode: string;
        payrollCode: string | undefined;
        workOn: Date;
      }> = [];

      for (const userCodeItem of userCodes) {
        for (const workOnDate of dataSchedule.workOn) {
          codeCounter++;
          allSchedules.push({
            scheduleCode: `SDC${String(codeCounter).padStart(6, "0")}`,
            userCode: userCodeItem,
            shiftCode: dataSchedule.shiftCode,
            payrollCode: payrollCode?.payrollCode,
            workOn: new Date(workOnDate),
          });
        }
      }

      await this.prisma.employeeSchedule.createMany({
        data: allSchedules,
      });

      return {
        totalUsers: userCodes.length,
        totalSchedules: allSchedules.length,
        dataSchedule: allSchedules,
      };
    } catch (e) {
      throw new HttpException(
        e.message || "Create schedule failed",
        e.status || 500,
      );
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
        orderBy: {
          workOn: "desc",
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
  async updateStatusSchedules(req: any) {
    try {
      const startDay = dayjs().startOf("day").toDate();
      const endDay = dayjs().endOf("day").toDate();

      await this.prisma.employeeSchedule.updateMany({
        where: {
          userCode: req.user.userCode,
          isActive: "Y",
          workOn: {
            gte: dayjs().startOf("day").toDate(),
            lte: dayjs().endOf("day").toDate(),
          },
        },
        data: {
          status: "INDAY",
        },
      });

      return { startDay, endDay };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getPercentSchedules(req: any) {
    try {
      const userCode = req.user.userCode;
      const today = dayjs();
      const listSchedulesInMonth = await this.prisma.employeeSchedule.findMany({
        where: {
          userCode,
          isActive: "Y",
          workOn: {
            gte: today.startOf("month").toDate(),
            lte: today.endOf("month").toDate(),
          },
        },
      });
      const listAttdenRecords = await this.prisma.attendanceRecord.findMany({
        where: {
          userCode,
          status: "PRESENT",
          workDay: {
            gte: today.startOf("month").toDate(),
            lte: today.endOf("month").toDate(),
          },
        },
      });
      const timesList = listSchedulesInMonth.map((item) =>
        dayjs(item.workOn).format("YYYY-MM-DD"),
      );
      console.log(`[===============> timelist 1 | `, timesList);
      const ListAttdenRecordInSchedule = listAttdenRecords.filter((item) =>
        timesList.includes(dayjs(item.workDay).format("YYYY-MM-DD")),
      );
      return {
        percent:
          ListAttdenRecordInSchedule.length > 0
            ? (
                (ListAttdenRecordInSchedule.length /
                  listSchedulesInMonth.length) *
                100
              ).toPrecision(2)
            : 0,
        totalDays: listSchedulesInMonth.length,
        totalAttden: ListAttdenRecordInSchedule.length,
      };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getSchedulesForAdmin(req: any) {
    try {
      const { startDate, endDate } = req.query;

      let startOfWeek: Date;
      let endOfWeek: Date;

      // Nếu có startDate và endDate
      if (startDate && endDate) {
        const start = dayjs(startDate);
        const end = dayjs(endDate);

        // Nếu startDate và endDate là cùng một ngày
        if (start.isSame(end, "day")) {
          startOfWeek = start.startOf("day").toDate();
          endOfWeek = start.endOf("day").toDate();
        } else {
          // Nếu khác ngày thì lấy khoảng từ startDate đến endDate
          startOfWeek = start.startOf("day").toDate();
          endOfWeek = end.endOf("day").toDate();
        }
      } else {
        const today = dayjs();

        const dayOfWeek = today.day();

        const diffToMonday = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;

        startOfWeek = today.add(diffToMonday, "day").startOf("day").toDate();

        endOfWeek = dayjs(startOfWeek).add(6, "day").endOf("day").toDate();

        console.log("[==================>", startOfWeek, endOfWeek);
      }

      const schedules = await this.prisma.employeeSchedule.findMany({
        where: {
          isActive: "Y",
          workOn: {
            gte: startOfWeek,
            lte: endOfWeek,
          },
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
          user: {
            select: {
              userCode: true,
              fullName: true,
              email: true,
              avatar: true,
            },
          },
        },
        orderBy: [
          {
            workOn: "asc",
          },
          {
            userCode: "asc",
          },
        ],
      });

      // Group schedules by user
      const groupedByUser = schedules.reduce((acc, schedule) => {
        const userCode = schedule.userCode;
        if (!acc[userCode]) {
          acc[userCode] = {
            user: schedule.user,
            schedules: [],
          };
        }
        acc[userCode].schedules.push({
          scheduleCode: schedule.scheduleCode,
          workOn: schedule.workOn,
          status: schedule.status,
          shiftCode: schedule.shiftCode,
          shift: schedule.shift,
          payrollCode: schedule.payrollCode,
        });
        return acc;
      }, {});

      const result = Object.values(groupedByUser);

      return {
        startDate: startOfWeek,
        endDate: endOfWeek,
        total: result.length,
        data: result,
      };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
