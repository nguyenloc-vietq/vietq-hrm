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

@Controller("schedule")
export class ScheduleController {
  constructor(private readonly scheduleService: ScheduleService) {}

  @Post("create")
  async create(
    @Body(ValidationPipe) dataSchedule: CreateScheduleDto,
    @Req() req: Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.scheduleService.create(dataSchedule, req),
      200,
      "",
    );
  }
}
