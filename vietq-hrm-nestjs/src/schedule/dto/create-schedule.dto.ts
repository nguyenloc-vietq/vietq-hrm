import {
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  ValidateIf,
} from "class-validator";

export class CreateScheduleDto {
  @ValidateIf((o) => o.action !== "all")
  @IsNotEmpty()
  @IsString()
  userCode?: string;

  @IsNotEmpty()
  @IsString()
  shiftCode: string;

  @IsArray()
  workOn: Array<Date>;

  @IsOptional()
  @IsString()
  action?: string;
}
