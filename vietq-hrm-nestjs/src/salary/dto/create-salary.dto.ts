import { IsNumber, IsString } from "class-validator";

export class CreateSalaryDto {
  @IsString()
  userCode: string;
  @IsNumber()
  baseSalary: number;
  @IsNumber()
  overtimeRate: number;
  @IsNumber()
  otNightRate: number;
  @IsNumber()
  nightRate: number;
  @IsNumber()
  lateRate: number;
  @IsNumber()
  earlyRate: number;
  @IsString()
  effectiveDate: string;
}
