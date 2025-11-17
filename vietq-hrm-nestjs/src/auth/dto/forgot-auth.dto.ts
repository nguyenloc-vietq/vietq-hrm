import {
  IsEmail,
  IsString,
  IsStrongPassword,
  MaxLength,
  MinLength,
} from "class-validator";

export class ForgotAuthDto {
  @IsEmail()
  email: string;
  @IsString()
  token: string;
  @IsString()
  @MinLength(6)
  @MaxLength(20)
  @IsStrongPassword()
  password: string;
  @IsString()
  @MinLength(6)
  @MaxLength(20)
  @IsStrongPassword()
  passwordConfirm: string;
}
