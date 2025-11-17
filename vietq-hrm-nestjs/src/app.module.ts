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
import { ShiftModule } from "./shift/shift.module";
import { ScheduleModule } from "./schedule/schedule.module";
import { AttendanceModule } from "./attendance/attendance.module";
import { CodeGeneratorModule } from "./code-generator/code-generator.module";
import { UserModule } from "./user/user.module";
import { FileModule } from "./file/file.module";
import { PermissionModule } from "./permission/permission.module";
import { NotificationModule } from "./notification/notification.module";
import { TokenService } from "./token/token.service";
import { FirebaseModule } from "./firebase/firebase.module";

@Module({
  imports: [
    DatabaseModule,
    FirebaseModule,
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    AuthModule,
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: "10d" },
    }),
    DatabaseModule,
    ShiftModule,
    ScheduleModule,
    AttendanceModule,
    CodeGeneratorModule,
    UserModule,
    FileModule,
    PermissionModule,
    NotificationModule,
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
    TokenService,
  ],
})
export class AppModule {}
