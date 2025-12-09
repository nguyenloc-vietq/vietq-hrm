import { Type } from "class-transformer";
import { IsArray, IsBoolean, IsString, ValidateNested } from "class-validator";

export class ItemPayrollDto {
  @IsString()
  isLocked: string;
  @IsBoolean()
  isActive: boolean;
  @IsString()
  startDate: string;
  @IsString()
  endDate: string;
}

export class CreatePayrollDto {
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ItemPayrollDto)
  listCreatePayroll: ItemPayrollDto[];
}
