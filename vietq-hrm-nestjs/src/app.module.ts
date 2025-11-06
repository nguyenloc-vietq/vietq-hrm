import { Module } from "@nestjs/common";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { ConfigModule } from "@nestjs/config";
import { MyLoggerDev } from "./logger/my.logger.dev";
import { AuthModule } from "./auth/auth.module";
import { JwtModule } from "@nestjs/jwt";
import { DatabaseModule } from "./database/database.module";
import * as process from "node:process";
import { APP_GUARD } from "@nestjs/core";
import { AuthGuard } from "./auth/auth.guard";
import { PermissionRbacGuard } from "./permission-rbac/permission-rbac.guard";

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    AuthModule,
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: "1d" },
    }),
    DatabaseModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    MyLoggerDev,
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
    {
      provide: APP_GUARD,
      useClass: PermissionRbacGuard,
    },
  ],
})
export class AppModule {}
