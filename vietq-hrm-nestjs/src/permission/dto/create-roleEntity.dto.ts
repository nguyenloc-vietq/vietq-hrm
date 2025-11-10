import { IsNotEmpty, IsNumber, IsString } from "class-validator";

export class CreatePermissionDto {
  @IsNumber()
  @IsNotEmpty()
  nameCode: number;
  @IsString()
  @IsNotEmpty()
  name: string;
  desc: string;
}
