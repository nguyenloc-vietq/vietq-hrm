/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Req,
} from "@nestjs/common";
import { AttendanceService } from "./attendance.service";
import { CreateAttendanceDto } from "./dto/create-attendance.dto";
import { UpdateAttendanceDto } from "./dto/update-attendance.dto";
import { ResponseDataSuccess } from "src/global/globalClass";
import { CheckInAttendanceDto } from "./dto/checkin-attendance.dto";

@Controller("attendance")
export class AttendanceController {
  constructor(private readonly attendanceService: AttendanceService) {}

  @Post("check-in")
  async checkIn(
    @Body() checkInAttendanceDto: CheckInAttendanceDto,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.attendanceService.checkIn(checkInAttendanceDto, req),
      200,
      "check in success",
    );
  }
  @Post("check-out")
  async checkOut(
    @Body() checkInAttendanceDto: CheckInAttendanceDto,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.attendanceService.checkOut(checkInAttendanceDto, req),
      200,
      "check in success",
    );
  }

  @Get("time-sheet")
  async getTimeSheet(@Req() req: any): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.attendanceService.getTimeSheet(req),
      200,
      "get time sheet success",
    );
  }

  @Get("admin-list-attendance")
  async listAttendance(@Req() req: any): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.attendanceService.adminListAttendance(req),
      200,
      "list attendance success",
    );
  }
}
