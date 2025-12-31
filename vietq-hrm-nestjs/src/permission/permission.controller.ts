import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ValidationPipe,
  Req,
} from "@nestjs/common";
import { PermissionService } from "./permission.service";
import { ResponseDataSuccess } from "src/global/globalClass";
import { CreatePermissionDto } from "./dto/create-roleEntity.dto";
import { DeletePermissionDto } from "./dto/delete-permission.dto";
import { AddRolePermissionDto } from "./dto/add-permission.dto";
import { ApiBearerAuth } from "@nestjs/swagger";
@ApiBearerAuth("access-token")
@Controller("permission")
export class PermissionController {
  constructor(private readonly permissionService: PermissionService) {}

  @Post("create")
  async createPermission(
    @Body(ValidationPipe) createPermission: CreatePermissionDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.permissionService.createPermission(createPermission),
      200,
      "create permission success",
    );
  }

  @Get("list-permission")
  async getListPermission(): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.permissionService.getListPermission(),
      200,
      "get list permission success",
    );
  }

  @Delete("delete-rule-permission")
  async deletePermission(
    @Body() deletePermission: DeletePermissionDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.permissionService.deletePermission(deletePermission),
      200,
      "delete permission success",
    );
  }

  @Post("add-role-permission")
  async addRolePermission(
    @Body() addRolePermission: AddRolePermissionDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.permissionService.addRolePermission(addRolePermission),
      200,
      "add role permission success",
    );
  }

  @Delete("remove-rule-permission")
  async removeRolePermission(
    @Body() addRolePermission: AddRolePermissionDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.permissionService.removeRolePermission(addRolePermission),
      200,
      "remove role permission success",
    );
  }
  @Get("my-permissions")
  async getMyPermissions(
    @Req() req, // req.user thường chứa thông tin từ JWT Strategy
  ): Promise<ResponseDataSuccess<object>> {
    const userId = req.user.id; // Đảm bảo key này khớp với payload token của bạn
    return new ResponseDataSuccess(
      await this.permissionService.getCurrentUserPermissions(userId),
      200,
      "Get current user permissions success",
    );
  }
}
