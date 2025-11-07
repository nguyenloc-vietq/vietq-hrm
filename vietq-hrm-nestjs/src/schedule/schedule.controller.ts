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
  ValidationPipe,
} from "@nestjs/common";
import { ScheduleService } from "./schedule.service";
import { CreateScheduleDto } from "./dto/create-schedule.dto";
import { UpdateScheduleDto } from "./dto/update-schedule.dto";
import { ResponseDataSuccess } from "../global/globalClass";
import { PermissionRequired } from "src/common/custom-decorator";

@Controller("schedule")
export class ScheduleController {
  constructor(private readonly scheduleService: ScheduleService) {}

  @Post("create")
  @PermissionRequired("CREATE_SCHEDULE")
  async create(
    @Body(
      new ValidationPipe({
        transform: true,
      }),
    )
    dataSchedule: CreateScheduleDto,
    @Req() req: Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.scheduleService.create(dataSchedule, req),
      200,
      "",
    );
  }

  @Get("get-month")
  // @PermissionRequired("READ_SCHEDULE")
  async getSchedulesInMonth(
    @Req() req: Request,
  ): Promise<ResponseDataSuccess<any>> {
    return new ResponseDataSuccess(
      await this.scheduleService.getSchedulesInMonth(req),
      200,
      "get schedules success",
    );
  }
  @Get("get-schedule")
  async getScheduleInDay(
    @Req() req: Request,
  ): Promise<ResponseDataSuccess<any>> {
    return new ResponseDataSuccess(
      await this.scheduleService.getSchedulesInDay(req),
      200,
      "get schedules success",
    );
  }
}
