import { IsNotEmpty, IsString } from "class-validator";

export class CheckInAttendanceDto {
  @IsString()
  @IsNotEmpty()
  ssid: string;
}
