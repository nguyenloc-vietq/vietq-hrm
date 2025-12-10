import { RegistrationStatus } from "@prisma/client";
import { IsNotEmpty, IsString } from "class-validator";

export class ApproveRegistrationDto {
  @IsString()
  @IsNotEmpty()
  registrationCode: string;
  @IsString()
  @IsNotEmpty()
  status: RegistrationStatus;
}
