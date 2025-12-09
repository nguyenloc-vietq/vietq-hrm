import * as process from "node:process";

import { APP_GUARD } from "@nestjs/core";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { AttendanceModule } from "./attendance/attendance.module";
import { AuthGuard } from "./auth/auth.guard";
import { AuthModule } from "./auth/auth.module";
import { CodeGeneratorModule } from "./code-generator/code-generator.module";
import { ConfigModule } from "@nestjs/config";
import { DatabaseModule } from "./database/database.module";
import { FileModule } from "./file/file.module";
import { FirebaseModule } from "./firebase/firebase.module";
import { JwtModule } from "@nestjs/jwt";
import { Module } from "@nestjs/common";
import { MyLoggerDev } from "./logger/my.logger.dev";
import { NotificationModule } from "./notification/notification.module";
import { PermissionModule } from "./permission/permission.module";
import { PermissionRbacGuard } from "./permission-rbac/permission-rbac.guard";
import { ScheduleModule } from "./schedule/schedule.module";
import { ShiftModule } from "./shift/shift.module";
import { TokenService } from "./token/token.service";
import { UserModule } from "./user/user.module";
import { SalaryModule } from './salary/salary.module';
import { PayrollModule } from './payroll/payroll.module';

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
    SalaryModule,
    PayrollModule,
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
