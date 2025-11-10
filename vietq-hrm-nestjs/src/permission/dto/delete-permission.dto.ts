import { IsNumber } from "class-validator";

export class DeletePermissionDto {
  @IsNumber()
  id: number;
}
