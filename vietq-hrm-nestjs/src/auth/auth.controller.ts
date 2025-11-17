/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Req,
  ValidationPipe,
} from "@nestjs/common";
import { AuthService } from "./auth.service";
import { LoginAuthDto, LoginAuthRespone } from "./dto/login-auth.dto";
import { RegisterAuthDto } from "./dto/register-auth.dto";
import { AuthGuard } from "./auth.guard";
import { ApiOperation, ApiResponse } from "@nestjs/swagger";
import { ResponseDataSuccess } from "src/global/globalClass";
import { PermissionRequired } from "src/common/custom-decorator";
import { PermitAll } from "src/common/custom-decorator";
import { ForgotAuthDto } from "./dto/forgot-auth.dto";

@Controller("auth")
// @PermitAll()
export class AuthController {
  constructor(private readonly authService: AuthService) {}
  @ApiOperation({ summary: "Login user" })
  @ApiResponse({
    status: 200,
    description: "OK",
    type: LoginAuthRespone,
  })
  @Post("login")
  @PermitAll()
  async login(
    @Body() user: LoginAuthDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(await this.authService.login(user), 200, "");
  }

  @ApiOperation({ summary: "Register user" })
  @Post("register")
  @PermitAll()
  @PermissionRequired("ADD_USER")
  async create(
    @Body(ValidationPipe) user: RegisterAuthDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.authService.create(user),
      200,
      "",
    );
  }

  @ApiOperation({ summary: "Check authentication" })
  @Get("check-auth")
  async checkAuth(@Req() req): Promise<ResponseDataSuccess<Array<any>>> {
    console.log(`[===============> this user | ${req.user}`);
    return new ResponseDataSuccess([], 200, "");
  }

  @ApiOperation({ summary: "Get profile user" })
  @Get("profile")
  @PermissionRequired("QUERY")
  async getProfile(@Req() req): Promise<ResponseDataSuccess<Array<any>>> {
    return new ResponseDataSuccess(req.permission, 200, "");
  }

  @Post("sent-otp")
  @PermitAll()
  async sentOtp(
    @Body() body: any,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.authService.sentOtp(body.email, req),
      200,
      "sent otp success",
    );
  }

  @Post("validate-otp")
  @PermitAll()
  async validateOtp(@Req() req: any): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.authService.validateOtp(req),
      200,
      "validate otp success",
    );
  }

  @Post("change-password")
  @PermitAll()
  async changePassword(
    @Body(ValidationPipe) newPassword: ForgotAuthDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.authService.changePassword(newPassword),
      200,
      "change password success",
    );
  }
}
