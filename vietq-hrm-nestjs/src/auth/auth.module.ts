import { Module } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { AuthController } from "./auth.controller";
import { TokenService } from "../token/token.service";
import { RedisModule } from "../redis/redis.module";
import { SmtpModule } from "src/smtp/smtp.module";

@Module({
  imports: [RedisModule, SmtpModule],
  controllers: [AuthController],
  exports: [AuthService],
  providers: [AuthService, TokenService],
})
export class AuthModule {}
