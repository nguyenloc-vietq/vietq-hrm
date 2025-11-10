import { IsArray, IsNotEmpty, IsString } from "class-validator";

export class CreateScheduleDto {
  @IsNotEmpty()
  @IsString()
  shiftCode: string;
  @IsArray()
  workOn: Array<Date>;
}
