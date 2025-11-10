import { DatabaseService } from "./../database/database.service";
import { HttpException, Injectable, Req } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
// import { PrismaService } from "src/services/prisma.services";
import { RegisterAuthDto } from "./dto/register-auth.dto";
import { LoginAuthDto } from "./dto/login-auth.dto";
import e from "express";
import { comparePassword, hashPassword } from "./utils/hash.utils";

@Injectable()
export class AuthService {
  constructor(
    // private prisma: PrismaService,
    private readonly prisma: DatabaseService,
    private jwtService: JwtService,
  ) {}

  async create(user: RegisterAuthDto) {
    //check user is exits
    const exitsUser = await this.prisma.user.findUnique({
      where: {
        email: user.email,
      },
    });
    if (exitsUser) throw new HttpException("User is already exits", 200);
    // hash password
    const passwordHash = await hashPassword(user.password);
    //create user
    try {
      const newDataUser = await this.prisma.user.create({
        data: {
          companyCode: user.companyCode,
          email: user.email,
          passwordHash: passwordHash,
          userCode: user.userCode,
          fullName: user.fullName,
          phone: user.phone,
        },
      });
      return newDataUser;
    } catch (error) {
      throw new Error("Error create user");
    }
  }

  async login(user: LoginAuthDto) {
    const exitsUser = await this.prisma.user.findUnique({
      where: {
        email: user.email,
      },
    });
    if (!exitsUser) throw new HttpException("User not exits", 200);
    // check password
    const compPassword = await comparePassword(
      user.password,
      exitsUser.passwordHash,
    );
    if (!compPassword) throw new HttpException("Password not correct", 401);
    const { passwordHash, ...payload } = exitsUser;
    const accessToken = this.jwtService.sign({ ...payload });
    return {
      ...payload,
      accessToken,
    };
  }

  async getProfile(@Req() req) {
    console.log(`[===============> this req | ${req}`);
    return "OK pass guard";
  }
  async getUserPermission(userId: number) {
    console.log(`[===============> USER ID | ${userId}`);
    const data = await this.prisma.user.findMany({
      where: {
        id: userId,
      },
      include: {
        // passwordHash: false,
        userRoles: {
          select: {
            role: {
              select: {
                rolePermissions: {
                  select: {
                    permission: true,
                  },
                },
              },
            },
          },
        },
      },
    });
    const reslut = data.map((user) => {
      const { passwordHash, userRoles, ...thisUser } = user;
      return {
        ...thisUser,
        rolePermissions: userRoles
          .map((role) => role.role.rolePermissions)
          .flat()
          .map((rolePermission) => rolePermission.permission),
      };
    });
    return reslut;
  }
}
