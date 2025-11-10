import { IsArray, IsNotEmpty, IsNumber } from "class-validator";

export class AddRolePermissionDto {
  @IsNotEmpty()
  @IsNumber()
  roleId: number;
  @IsNotEmpty()
  @IsArray()
  permissionId: Array<number>;
}
