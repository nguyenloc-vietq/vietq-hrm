import { IsDateString, IsNotEmpty, IsNumber, IsString } from "class-validator";

export class CreateScheduleDto {
  @IsNotEmpty()
  @IsNumber()
  shiftId: number;
  @IsNotEmpty()
  @IsString()
  scheduleCode: string;
  @IsNotEmpty()
  @IsDateString()
  workOn: Date;
}
