import { IsBoolean, IsNumber, IsOptional, IsString } from "class-validator";

export class UpdatePayrollDto {
  @IsString()
  payrollCode: string;
  @IsString()
  @IsOptional()
  payrollName: string;
  @IsString()
  @IsOptional()
  isLocked: string;
  @IsBoolean()
  @IsOptional()
  isActive: boolean;
  @IsString()
  @IsOptional()
  startDate: string;
  @IsString()
  @IsOptional()
  endDate: string;
}

export class UpdatePayrollConfigDto {
  @IsNumber()
  @IsOptional()
  startDay: number;
  @IsNumber()
  @IsOptional()
  endDay: number;
  @IsNumber()
  @IsOptional()
  paymentDelayDays: number;
  @IsBoolean()
  @IsOptional()
  isActive: boolean;
}
