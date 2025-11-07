import { IsDateString, IsNotEmpty, IsNumber, IsString } from "class-validator";

export class CreateScheduleDto {
  @IsNotEmpty()
  @IsString()
  shiftCode: string;
  @IsNotEmpty()
  @IsString()
  scheduleCode: string;
  @IsNotEmpty()
  @IsDateString()
  workOn: Date;
}
