import { HttpException, Injectable, Req } from "@nestjs/common";
import { CreateAttendanceDto } from "./dto/create-attendance.dto";
import { UpdateAttendanceDto } from "./dto/update-attendance.dto";
import { DatabaseService } from "src/database/database.service";
import dayjs from "dayjs";
import { CheckInAttendanceDto } from "./dto/checkin-attendance.dto";

@Injectable()
export class AttendanceService {
  constructor(private readonly prisma: DatabaseService) {}

  async checkIn(checkInAttendanceDto: CheckInAttendanceDto, @Req() req) {
    const workOn = new Date().toISOString();
    const today = dayjs();
    const startOfDay = today.startOf("day").toDate();
    const endOfDay = today.endOf("day").toDate();
    // check exits check-in
    const companyInfoSsid = await this.prisma.user.findFirst({
      where: {
        userCode: req.user.userCode,
      },
      select: {
        company: {
          select: {
            ssid: true,
          },
        },
      },
    });

    //check ip in offices

    if (companyInfoSsid?.company.ssid !== null) {
      const arrIp = JSON.parse(companyInfoSsid?.company.ssid as string);
      if (!arrIp.includes(req.ip)) {
        throw new HttpException("Check in fail, you are not in office", 400);
      }
    }

    const exitsCheckIn = await this.prisma.attendanceRecord.findFirst({
      where: {
        workDay: {
          lte: endOfDay,
          gte: startOfDay,
        },
        userCode: req.user.userCode,
      },
    });
    if (exitsCheckIn) {
      throw new HttpException("Already check in", 400);
    }

    const dataPayroll = await this.prisma.payroll.findFirst({
      where: {
        startDate: { lte: workOn },
        endDate: { gte: workOn },
        isActive: true,
      },
      select: {
        payrollCode: true,
      },
    });

    const scheduleToday = await this.prisma.employeeSchedule.findFirst({
      where: {
        workOn: {
          gte: startOfDay,
          lte: endOfDay,
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
    console.log(scheduleToday);

    const startTime = dayjs(
      `${dayjs().format("YYYY-MM-DD")}T${scheduleToday?.shift.startTime}`,
    );
    const newAttendance = await this.prisma.attendanceRecord.create({
      data: {
        userCode: req.user.userCode,
        payrollCode: dataPayroll!.payrollCode,
        workDay: today.toDate(),
        timeIn: today.toDate(),
        status: "ABSENT",
        lateMinutes: today.isAfter(startTime)
          ? Number(today.diff(startTime, "minute"))
          : 0,
      },
    });
    return {
      ...newAttendance,
    };
    // return { ...newAttendance };
  }
  async checkOut(CheckOutAttendanceDto: CheckInAttendanceDto, @Req() req) {
    const workOn = new Date().toISOString();
    const today = dayjs();
    const startOfDay = today.startOf("day").toDate();
    const endOfDay = today.endOf("day").toDate();

    const companyInfoSsid = await this.prisma.user.findFirst({
      where: {
        userCode: req.user.userCode,
      },
      select: {
        company: {
          select: {
            ssid: true,
          },
        },
      },
    });

    //check ip in offices

    if (companyInfoSsid?.company.ssid !== null) {
      const arrIp = JSON.parse(companyInfoSsid?.company.ssid as string);
      if (!arrIp.includes(req.ip)) {
        throw new HttpException("Check in fail, you are not in office", 400);
      }
    }

    const exitsCheckIn = await this.prisma.attendanceRecord.findFirst({
      where: {
        workDay: {
          lte: endOfDay,
          gte: startOfDay,
        },
        userCode: req.user.userCode,
      },
    });
    if (!exitsCheckIn || exitsCheckIn.status === "PRESENT") {
      throw new HttpException("Not check in or already check out", 400);
    }
    const newAttendance = await this.prisma.attendanceRecord.update({
      where: {
        id: exitsCheckIn.id,
      },
      data: {
        timeOut: today.toDate(),
        status: "PRESENT",
        earlyMinutes: today.diff(exitsCheckIn.timeIn, "minute"),
      },
    });
    return {
      ...newAttendance,
    };
  }

  async getTimeSheet(@Req() req) {
    const { startMonth, endMonth } = req.query;
    const startOfMonth = dayjs().startOf("month");
    const endOfMonth = dayjs().endOf("month");
    const today = req.query.today;
    try {
      // const dataTimeSheet = await this.prisma.payroll.findMany({
      //   where: {
      //     startDate: {
      //       lte: endMonth ? endMonth : endOfMonth.toDate(),
      //       gte: startMonth ? startMonth : startOfMonth.toDate(),
      //     },
      //     isActive: true,
      //   },
      //   include: {
      //     company: {
      //       select: {
      //         companyName: true,
      //       },
      //     },
      //     attendanceRecs: true,
      //   },
      // });
      const dataTimeSheet = await this.prisma.payroll.findMany({
        where: {
          startDate: {
            lte: endMonth || endOfMonth.toDate(),
            gte: startMonth || startOfMonth.toDate(),
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
              workDay: {
                gte: today
                  ? dayjs(today).startOf("day").toDate()
                  : startOfMonth.toDate(),
                lte: today
                  ? dayjs(today).endOf("day").toDate()
                  : endOfMonth.toDate(),
              },
            },
          },
        },
      });
      return { ...dataTimeSheet[0] };
    } catch (error) {
      throw new HttpException("Get time sheet failed", 500);
    }
  }
}
