import { IsString, IsArray, IsOptional, IsEnum } from "class-validator";

export enum TestTargetType {
  ALL = "ALL",
  SINGLE = "SINGLE"
}

export class TestNotificationDto {
  @IsString()
  title: string;

  @IsString()
  body: string;

  @IsEnum(TestTargetType)
  targetType: TestTargetType;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  userCodeList?: string[];
}
