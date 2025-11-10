import { IsNumber, IsString } from "class-validator";
import { NotificationTargetType } from "@prisma/client";

export class CreateNotificationDto {
  @IsString()
  notificationType: string;
  @IsString()
  title: string;
  @IsString()
  body: string;
  @IsString()
  targetType: NotificationTargetType;
  scheduleTime: Date;
  @IsNumber()
  openSent: number;
}
