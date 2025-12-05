import { IsString } from "class-validator";

export class ReportPayrollDto {
  @IsString()
  userCode: string;
  @IsString()
  month: string;
}
