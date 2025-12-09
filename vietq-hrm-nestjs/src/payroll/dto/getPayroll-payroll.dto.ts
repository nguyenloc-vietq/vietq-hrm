import { IsString } from "class-validator";

export class GetPayrollDto {
  @IsString()
  month: string;
}
