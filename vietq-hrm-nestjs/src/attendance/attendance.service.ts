import { HttpException, Injectable, Req } from "@nestjs/common";
import { CreateAttendanceDto } from "./dto/create-attendance.dto";
import { UpdateAttendanceDto } from "./dto/update-attendance.dto";
import { DatabaseService } from "src/database/database.service";
import dayjs from "dayjs";
import { CheckInAttendanceDto } from "./dto/checkin-attendance.dto";
import getLateMinutes from "src/utils/converTime";

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

    const lateTime = getLateMinutes(
      today,
      "Asia/Ho_Chi_Minh",
      scheduleToday?.shift.startTime,
    );

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
    console.log(`[===============> workon | `, workOn);
    console.log(`[===============> datapayroll | `, dataPayroll);

    const newAttendance = await this.prisma.attendanceRecord.create({
      data: {
        userCode: req.user.userCode,
        payrollCode: dataPayroll!.payrollCode,
        workDay: today.toDate(),
        timeIn: today.toDate(),
        status: "ABSENT",
        lateMinutes: lateTime,
      },
    });
    return {
      ...newAttendance,
    };
    // return { ...newAttendance };
    // return {};
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
    console.log(`[===============> START MONTH | `, startOfMonth);
    console.log(`[===============> START MONTH | `, endOfMonth);
    const today = req.query.today;
    try {
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
              userCode: req.user.userCode,
              // workDay: today ? dayjs(today).toDate() : dayjs().toDate(),
              workDay: {
                gte: today
                  ? dayjs(today).startOf("day").toDate()
                  : startMonth
                    ? dayjs(startMonth).toDate()
                    : startOfMonth.toDate(),
                lte: today
                  ? dayjs(today).endOf("day").toDate()
                  : startMonth
                    ? dayjs(endMonth).toDate()
                    : endOfMonth.toDate(),
              },
            },
            orderBy: {
              workDay: "desc",
            },
          },
        },
      });
      console.log(
        `[===============> hdhdhhdh | `,
        dayjs(startMonth).endOf("day").toDate(),
      );
      return { ...dataTimeSheet[0] };
    } catch (error) {
      throw new HttpException("Get time sheet failed", 500);
    }
  }

  async adminListAttendance(req) {
    const { startDate, endDate } = req.query;
    if (!startDate || !endDate) {
      const startMonth = dayjs().startOf("month").toDate();
      const endMonth = dayjs().endOf("month").toDate();
      const listAttdent = await this.prisma.attendanceRecord.findMany({
        select: {
          id: true,
          userCode: true,
          payrollCode: true,
          workDay: true,
          timeIn: true,
          timeOut: true,
          status: true,
          lateMinutes: true,
          earlyMinutes: true,
          user: {
            select: {
              fullName: true,
              avatar: true,
              companyCode: true,
              userCode: true,
            },
          },
        },
        where: {
          workDay: {
            gte: startMonth,
            lte: endMonth,
          },
        },
      });
      return listAttdent;
    }
    try {
      const listAttdent = await this.prisma.attendanceRecord.findMany({
        select: {
          id: true,
          userCode: true,
          payrollCode: true,
          workDay: true,
          timeIn: true,
          timeOut: true,
          status: true,
          lateMinutes: true,
          earlyMinutes: true,
          user: {
            select: {
              fullName: true,
              avatar: true,
              companyCode: true,
              userCode: true,
            },
          },
        },
        where: {
          workDay: {
            gte: dayjs(startDate).startOf("day").toDate(),
            lte: dayjs(endDate).endOf("day").toDate(),
          },
        },
      });
      return listAttdent;
    } catch (error) {
      throw new HttpException("Get time sheet failed", 500);
    }
  }
}
