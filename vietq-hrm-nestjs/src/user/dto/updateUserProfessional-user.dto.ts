import { IsString } from "class-validator";

export class UpdateUserProfessionalDto {
  @IsString()
  userCode: string;
  @IsString()
  companyCode: string;
  @IsString()
  position: string;
  @IsString()
  employeeType: string;
}
