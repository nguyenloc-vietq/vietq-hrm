import { IsString } from "class-validator";

export class DevicesRegisterNotificationDto {
  @IsString()
  platform: "ios" | "android";
  @IsString()
  appVersion: string;
  @IsString()
  deviceId: string;
  @IsString()
  fcmToken: string;
  @IsString()
  userCode: string;
}
