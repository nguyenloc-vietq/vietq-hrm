/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Body,
  HttpException,
  Injectable,
  Param,
  Query,
  Req,
} from "@nestjs/common";
import { DatabaseService } from "src/database/database.service";
import { query } from "winston";
import { UpdateProfileDto, UpdateUserDto } from "./dto/update-user.dto";
import { UpdateUserProfessionalDto } from "./dto/updateUserProfessional-user.dto";

@Injectable()
export class UserService {
  constructor(private readonly prisma: DatabaseService) {}

  async getProfile(@Query() query: any) {
    try {
      const userCode = query.userCode;
      console.log(`[===============> USERCODE | ${userCode}`);
      const user = await this.prisma.user.findUnique({
        where: {
          userCode: userCode,
        },
      });
      if (!user) throw new HttpException("User not exits", 200);
      return user;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async profile(@Req() req) {
    try {
      const userCode = req.user.userCode;
      console.log(`[===============> USERCODE | ${userCode}`);
      const user = await this.prisma.user.findUnique({
        where: {
          userCode: userCode,
        },
        include: {
          company: {
            select: {
              address: true,
              companyName: true,
            },
          },
          userProfessionals: {
            select: {
              position: true,
              employeeType: true,
            },
          },
        },
      });
      if (!user) throw new HttpException("User not exits", 200);
      return user;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async update(user: UpdateUserDto) {
    try {
      const userCode = user.userCode;
      const newDataUser = await this.prisma.user.update({
        where: {
          userCode: userCode,
        },
        data: user,
      });
      return newDataUser;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async updateProfile(user: UpdateProfileDto, req: any) {
    try {
      const userCode = req.user.userCode;
      const newDataUser = await this.prisma.user.update({
        where: {
          userCode: userCode,
        },
        data: user,
      });
      return newDataUser;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async uploadAvatar(file: any, @Req() req: any) {
    try {
      const userCode = req.user.userCode;
      const newDataUser = await this.prisma.user.update({
        where: {
          userCode: userCode,
        },
        data: {
          avatar: file.filename,
        },
      });
      const result = {
        filePath: file.path,
        fileName: file.filename,
        originalName: file.originalname,
        dataUser: newDataUser,
      };
      return result;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async deleteUser(@Body() body: any) {
    try {
      const userCode = body.userCode;
      await this.prisma.user.update({
        where: {
          userCode: userCode,
        },
        data: {
          isActive: "N",
        },
      });
      return [];
    } catch (error) {
      throw new HttpException("Delete user failed, user not exits", 500);
    }
  }

  async updateUserProfessional(user: UpdateUserProfessionalDto) {
    try {
      const createNewUserProfeesional =
        await this.prisma.userProfessional.create({
          data: {
            ...user,
          },
        });
      return { ...createNewUserProfeesional };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async editUserProfessional(user: UpdateUserProfessionalDto) {
    try {
      const editUserProfessional = await this.prisma.userProfessional.update({
        where: {
          userCode: user.userCode,
        },
        data: {
          ...user,
        },
      });
      return { ...editUserProfessional };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
