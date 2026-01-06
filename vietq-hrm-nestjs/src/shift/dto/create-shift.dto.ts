import { IsDate, IsNotEmpty, IsOptional, IsString } from "class-validator";

export class CreateShiftDto {
  @IsOptional()
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
