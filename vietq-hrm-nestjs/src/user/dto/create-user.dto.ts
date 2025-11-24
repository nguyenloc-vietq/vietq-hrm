import { IsString } from "class-validator";

export class CreateUserDto {
  @IsString()
  fullName: string;
  @IsString()
  email: string;
  avatar: string;
  @IsString()
  phone: string;
  @IsString()
  position: string;
  @IsString()
  employeeType: string;
  @IsString()
  password: string;
}
