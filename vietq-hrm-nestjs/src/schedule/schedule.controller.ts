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
  Put,
} from "@nestjs/common";
import { ScheduleService } from "./schedule.service";
import { CreateScheduleDto } from "./dto/create-schedule.dto";
import { ResponseDataSuccess } from "../global/globalClass";
import { PermissionRequired } from "src/common/custom-decorator";
import { UpdateScheduleDto } from "./dto/update-schedule.dto";

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

  @Put("update")
  @PermissionRequired("UPDATE_SCHEDULE")
  async update(
    @Body(
      new ValidationPipe({
        transform: true,
      }),
    )
    dataSchedule: UpdateScheduleDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.scheduleService.update(dataSchedule),
      200,
      "update schedule success",
    );
  }
  @Delete("delete")
  @PermissionRequired("DELETE_SCHEDULE")
  async delete(
    @Body() body: { scheduleCode: string },
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.scheduleService.delete(body.scheduleCode),
      200,
      "delete schedule success",
    );
  }

  @Get("update-status-schedules")
  async updateStatusSchedules(
    @Req() req: Request,
  ): Promise<ResponseDataSuccess<any>> {
    return new ResponseDataSuccess(
      await this.scheduleService.updateStatusSchedules(req),
      200,
      "update status schedules success",
    );
  }
  @Get("get-percent-schedules")
  async getPercentSchedules(
    @Req() req: Request,
  ): Promise<ResponseDataSuccess<any>> {
    return new ResponseDataSuccess(
      await this.scheduleService.getPercentSchedules(req),
      200,
      "get percent schedules success",
    );
  }
}
