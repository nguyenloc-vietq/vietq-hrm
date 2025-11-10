import { IsNumber, IsString } from "class-validator";
import { NotificationTargetType } from "@prisma/client";

export class UpdateNotificationDto {
  notificationType: string;
  title: string;
  body: string;
  targetType: NotificationTargetType;
  scheduleTime: Date;
  openSent: number;
}
