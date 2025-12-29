import { IsString } from "class-validator";

export class ReportPayrollDto {
  @IsString()
  month: string;
}
