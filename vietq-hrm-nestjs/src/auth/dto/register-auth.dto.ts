import {
  IsEmail,
  IsNotEmpty,
  IsString,
  IsStrongPassword,
  Length,
} from "class-validator";

export class RegisterAuthDto {
  @IsString()
  @IsEmail()
  @IsNotEmpty()
  email: string;
  @IsString()
  @IsNotEmpty()
  userCode: string;
  @IsString()
  @IsNotEmpty()
  @Length(6, 100, {
    message: "Full name must be between 6 and 100 characters",
  })
  fullName: string;
  @IsString()
  @IsNotEmpty()
  @Length(10, 10, {
    message: "Phone must be 10 characters",
  })
  phone: string;
  @IsString()
  @IsNotEmpty()
  @Length(6, 20, {
    message: "Password must be between 6 and 20 characters",
  })
  @IsStrongPassword()
  password: string;
}
