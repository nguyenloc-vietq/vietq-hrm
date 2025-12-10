import { IsOptional, IsString } from "class-validator";
import { RegistrationType } from "@prisma/client";

export class CreateRegistrationDto {
  @IsString()
  startDate: string;
  @IsString()
  endDate: string;
  @IsString()
  reason: string;
  @IsString()
  type: RegistrationType;
  @IsString()
  @IsOptional()
  timeIn?: string;
  @IsString()
  @IsOptional()
  timeOut?: string;
}
