/* eslint-disable @typescript-eslint/no-explicit-any */
import { DatabaseService } from "./../database/database.service";
import { HttpException, Inject, Injectable, Req } from "@nestjs/common";
import { JwtService } from "@nestjs/jwt";
// import { PrismaService } from "src/services/prisma.services";
import { RegisterAuthDto } from "./dto/register-auth.dto";
import { LoginAuthDto } from "./dto/login-auth.dto";
import e from "express";
import { comparePassword, hashPassword } from "./utils/hash.utils";
import { randomInt } from "node:crypto";
import Redis from "ioredis";
import { TokenService } from "../token/token.service";
import { ForgotAuthDto } from "./dto/forgot-auth.dto";
import { MailerService } from "@nestjs-modules/mailer";
import { SmtpService } from "src/smtp/smtp.service";

@Injectable()
export class AuthService {
  constructor(
    // private prisma: PrismaService,
    private readonly prisma: DatabaseService,
    private readonly tokenService: TokenService,
    private readonly mailerService: SmtpService,
    private jwtService: JwtService,
    @Inject("REDIS_CLIENT") private readonly redisClient: Redis,
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

  async sentOtp(email: string, @Req() req: any) {
    try {
      const exitsUser = await this.prisma.user.findUnique({
        where: {
          email: email,
        },
      });

      if (!exitsUser) throw new HttpException("User not exits", 403);

      const otp = randomInt(100000, 999999).toString();

      const ttl = 120;

      await this.redisClient.set(`otp:${email}`, otp, "EX", ttl);

      console.log("#================> OTP", otp);
      //sent otp to email
      await this.mailerService.sendOtpEmail(email, otp);

      return {};
    } catch (e) {
      console.log(e.message);
      throw new HttpException("Sent otp failed", 403);
    }
  }

  async validateOtp(req) {
    try {
      const { email, otp } = req.body;
      console.log("#================> REQ", req.body);
      console.log(`[===============> REQ IP | ${req.ip}`);
      const savedOtp = await this.redisClient.get(`otp:${email}`);
      console.log("savedOtp", savedOtp);
      if (!savedOtp) throw new HttpException("Otp expired", 403);

      if (savedOtp !== otp) throw new HttpException("invalid otp", 403);

      await this.redisClient.del(`otp:${email}`);

      const token = this.tokenService.sign({
        email,
        iat: Date.now(),
      });

      await this.redisClient.set(`token:${email}`, token, "EX", 120);

      return {
        email,
        token,
      };
    } catch (e) {
      console.log(e.message);
      throw new HttpException(e.message, 403);
    }
  }

  async changePassword(newPassword: ForgotAuthDto) {
    try {
      const { email, password, passwordConfirm, token } = newPassword;

      const verifiToken = this.tokenService.verify(token);

      if (passwordConfirm !== password)
        throw new HttpException("Passwords do not match", 403);

      const savedToken = await this.redisClient.get(`token:${email}`);

      if (!savedToken || token !== savedToken)
        throw new HttpException("Invalid token", 403);

      if (!verifiToken || Date.now() - verifiToken.iat > 120 * 1000)
        throw new HttpException("Invalid token or token is expired", 403);

      const exitsUser = await this.prisma.user.findUnique({
        where: {
          email: email,
        },
      });
      if (!exitsUser) throw new HttpException("User not exits", 403);
      const newPasswordHash = await hashPassword(password);
      await this.prisma.user.update({
        where: {
          email: email,
        },
        data: {
          passwordHash: newPasswordHash,
        },
      });

      await this.redisClient.del(`token:${email}`);

      return {};
    } catch (e) {
      throw new HttpException(e.message, 403);
    }
  }
}
