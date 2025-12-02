/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Req,
  Query,
  Put,
  ValidationPipe,
  UseInterceptors,
  UploadedFile,
} from "@nestjs/common";
import { UserService } from "./user.service";
import { ResponseDataSuccess } from "src/global/globalClass";
import { query } from "winston";
import { UpdateProfileDto, UpdateUserDto } from "./dto/update-user.dto";
import { FileInterceptor } from "@nestjs/platform-express";
import { extname } from "path";
import { diskStorage } from "multer";
import { Request } from "express";
import { UpdateUserProfessionalDto } from "./dto/updateUserProfessional-user.dto";
import { CreateUserDto } from "./dto/create-user.dto";
import { ChangePasswordDto } from "./dto/changePassword-user.dto";

@Controller("user")
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get("user-profile")
  async getProfile(@Query() query: any): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.getProfile(query),
      200,
      "get profile success",
    );
  }

  @Get("profile")
  async profile(@Req() req): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.profile(req),
      200,
      "get profile success",
    );
  }

  @Put("user-update")
  async update(
    @Body(
      new ValidationPipe({
        whitelist: true, // loại bỏ các field không có trong DTO
        forbidNonWhitelisted: true, // tùy chọn: ném lỗi nếu có field lạ
        transform: true, // chuyển đổi body sang instance DTO
      }),
    )
    user: UpdateUserDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.update(user),
      200,
      "update profile success",
    );
  }

  @Put("update")
  async updateProfile(
    @Body(
      new ValidationPipe({
        whitelist: true, // loại bỏ các field không có trong DTO
        forbidNonWhitelisted: true, // tùy chọn: ném lỗi nếu có field lạ
        transform: true, // chuyển đổi body sang instance DTO
      }),
    )
    user: UpdateProfileDto,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.updateProfile(user, req),
      200,
      "update profile success",
    );
  }

  @Post("upload-avatar")
  @UseInterceptors(
    FileInterceptor("avatar", {
      storage: diskStorage({
        destination: "./src/uploads", // đường dẫn lưu file (local)
        filename: (req: Request, file: any, callback) => {
          // Tạo tên file duy nhất
          const uniqueSuffix =
            Date.now() + "-" + Math.round(Math.random() * 1e9);
          const ext = extname(file.originalname);
          callback(
            null,
            `${file.fieldname}/${file.fieldname}-${uniqueSuffix}${ext}`,
          );
        },
      }),
    }),
  )
  async uploadFile(
    @UploadedFile() file: any,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.uploadAvatar(file, req),
      200,
      "upload avatar success",
    );
  }

  @Delete("delete-user")
  async deleteUser(@Body() body: any): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.deleteUser(body),
      200,
      "delete user success",
    );
  }

  @Post("user-update-professional")
  async updateUserProfessional(
    @Body(ValidationPipe) user: UpdateUserProfessionalDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.updateUserProfessional(user),
      200,
      "update user professional success",
    );
  }

  @Put("update-user-professional")
  async editUserProfessional(
    @Body(ValidationPipe) user: UpdateUserProfessionalDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.editUserProfessional(user),
      200,
      "edit user professional success",
    );
  }

  @Post("create-user")
  async createUser(
    @Body(ValidationPipe) createUser: CreateUserDto,
    @Req() req,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.createUser(createUser, req),
      200,
      "create user success",
    );
  }

  @Post("change-password")
  async changePassword(
    @Body(ValidationPipe) newPassword: ChangePasswordDto,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.changePassword(newPassword, req),
      200,
      "change password success",
    );
  }

  @Get("list-user")
  async listUser(@Req() req): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.userService.listUser(req),
      200,
      "get list user success",
    );
  }
}
