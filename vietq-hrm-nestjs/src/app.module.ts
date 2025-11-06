import { Module } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { ConfigModule } from "@nestjs/config";
import { MyLoggerDev } from "./logger/my.logger.dev";
import { AuthModule } from "./auth/auth.module";
import { JwtModule } from "@nestjs/jwt";
import * as process from "node:process";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    AuthModule,
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET as string,
      signOptions: {
        expiresIn: "1d",
      },
    }),
  ],
  controllers: [AppController],
  providers: [AppService, MyLoggerDev],
})
export class AppModule {}
