import {
  IsEmail,
  IsEmpty,
  IsNotEmpty,
  IsPhoneNumber,
  IsString,
} from "class-validator";

export class UpdateUserDto {
  @IsString()
  @IsNotEmpty()
  userCode: string;
  @IsString()
  @IsEmail()
  email: string;
  @IsString()
  phone: string;
  @IsString()
  fullName: string;
  isActive: string;
}

export class UpdateProfileDto {
  @IsEmail()
  email: string;
  @IsString()
  phone: string;
  @IsString()
  fullName: string;
  @IsString()
  address: string;
}
