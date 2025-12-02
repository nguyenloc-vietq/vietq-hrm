import { IsArray, IsNotEmpty, IsString } from "class-validator";

export class CreateScheduleDto {
  @IsNotEmpty()
  @IsString()
  userCode: string;
  @IsNotEmpty()
  @IsString()
  shiftCode: string;
  @IsArray()
  workOn: Array<Date>;
}
