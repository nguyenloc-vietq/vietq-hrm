import { IsArray, IsNotEmpty, IsString } from "class-validator";

export class UpdateScheduleDto {
  @IsNotEmpty()
  @IsArray()
  scheduleCode: Array<string>;
  @IsNotEmpty()
  @IsString()
  shiftCode: string;
  @IsNotEmpty()
  @IsArray()
  workOn: Array<Date>;
}
