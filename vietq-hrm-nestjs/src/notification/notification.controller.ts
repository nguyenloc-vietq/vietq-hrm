/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Req,
  Param,
  Query,
  UseGuards,
  Request,
  UsePipes,
  ValidationPipe,
  Delete,
  Put,
} from "@nestjs/common";
import { NotificationService } from "./notification.service";
import { ResponseDataSuccess } from "../global/globalClass";
import { DevicesRegisterNotificationDto } from "./dto/devicesRegister-notification.dto";
import { CreateNotificationDto } from "./dto/create-notification.dto";
import { UpdateNotificationDto } from "./dto/update-notification.dto";

@Controller("notification")
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  //user notification
  @Post("user/devices/register")
  async devicesRegister(
    @Body(ValidationPipe) dataRegister: DevicesRegisterNotificationDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.devicesRegister(dataRegister),
      200,
      "Register devices is successfully!",
    );
  }

  @Patch("user/devices/status")
  async devicesStatus(@Req() req: any): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.devicesStatus(req.user.userCode),
      200,
      "Update status devices is successfully!",
    );
  }

  @Get("user/list-notification")
  async listNotification(
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.listNotification(req.user.userCode),
      200,
      "Get list notification is successfully!",
    );
  }

  @Get("user/notifications/:notificationCode")
  async detailNotification(
    @Req() req: any,
    @Param("notificationCode") notificationCode: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.detailNotification(
        req.user.userCode,
        notificationCode,
      ),
      200,
      "Get detail notification is successfully!",
    );
  }

  @Patch("user/notifications/:notificationCode/read")
  async userReadNotification(
    @Req() req: any,
    @Param("notificationCode") notificationCode: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.userReadNotification(
        req.user.userCode,
        notificationCode,
      ),
      200,
      "Update status notification is successfully!",
    );
  }

  @Delete("user/notifications/:notificationCode")
  async userRemoveNotification(
    @Req() req: any,
    @Param("notificationCode") notificationCode: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.userRemoveNotification(
        req.user.userCode,
        notificationCode,
      ),
      200,
      "Remove notification is successfully!",
    );
  }

  @Post("admin/create-notifications")
  async adminCreateNotification(
    @Body(ValidationPipe) createNotification: CreateNotificationDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.adminCreateNotification(
        createNotification,
      ),
      200,
      "Create notification is successfully!",
    );
  }

  @Get("admin/list-notifications")
  async adminGetListNotification(): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.adminGetListNotification(),
      200,
      "Get list notification is successfully!",
    );
  }

  @Get("admin/notifications/:notificationCode")
  async adminDetailNotification(
    @Param("notificationCode") notificationCode: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.adminDetailNotification(notificationCode),
      200,
      "Get detail notification is successfully!",
    );
  }

  @Put("admin/notifications/:notificationCode")
  async adminUpdateNotification(
    @Param("notificationCode") notificationCode: string,
    @Body(ValidationPipe) updateNotification: UpdateNotificationDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.adminUpdateNotification(
        notificationCode,
        updateNotification,
      ),
      200,
      "Update notification is successfully!",
    );
  }

  @Delete("admin/notifications/:notificationCode")
  async adminRemoveNotification(
    @Param("notificationCode") notificationCode: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.notificationService.adminRemoveNotification(notificationCode),
      200,
      "Remove notification is successfully!",
    );
  }
}
