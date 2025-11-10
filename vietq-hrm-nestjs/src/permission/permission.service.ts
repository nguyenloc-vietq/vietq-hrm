import { HttpException, Injectable } from "@nestjs/common";
import { DatabaseService } from "src/database/database.service";
import { CreatePermissionDto } from "./dto/create-roleEntity.dto";
import { DeletePermissionDto } from "./dto/delete-permission.dto";
import { AddRolePermissionDto } from "./dto/add-permission.dto";

@Injectable()
export class PermissionService {
  constructor(private readonly prisma: DatabaseService) {}

  async createPermission(createPermission: CreatePermissionDto) {
    try {
      const dataPermission = await this.prisma.permission.create({
        data: {
          nameCode: createPermission.nameCode,
          name: createPermission.name,
          desc: createPermission.desc,
        },
      });
      return { ...dataPermission };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getListPermission() {
    try {
      const dataPermission = await this.prisma.permission.findMany();
      return dataPermission;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async deletePermission(deletePermission: DeletePermissionDto) {
    try {
      await this.prisma.permission.update({
        where: {
          id: deletePermission.id,
        },
        data: {
          isActive: "N",
        },
      });
      return [];
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async addRolePermission(addRolePermission: AddRolePermissionDto) {
    try {
      await this.prisma.rolePermission.createMany({
        data: addRolePermission.permissionId.map((permissionId) => ({
          roleId: addRolePermission.roleId,
          permissionId: permissionId,
        })),
      });
      return [];
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async removeRolePermission(addRolePermission: AddRolePermissionDto) {
    try {
      if (
        !addRolePermission?.roleId ||
        !addRolePermission?.permissionId?.length
      ) {
        throw new HttpException("roleId hoặc permissionId không hợp lệ", 500);
      }

      await this.prisma.rolePermission.deleteMany({
        where: {
          AND: [
            { roleId: addRolePermission.roleId },
            { permissionId: { in: addRolePermission.permissionId } },
          ],
        },
      });
      return [];
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
