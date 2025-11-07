import { IsDate, IsNotEmpty, IsString } from "class-validator";

export class CreateShiftDto {
  @IsNotEmpty()
  @IsString()
  shiftCode: string;
  @IsNotEmpty()
  @IsString()
  name: string;
  @IsNotEmpty()
  @IsString()
  startTime: string;
  @IsNotEmpty()
  @IsString()
  endTime: string;
  allowableDelay: number;
}
