import { Module } from "@nestjs/common";
import { NotificationService } from "./notification.service";
import { NotificationController } from "./notification.controller";
import { CodeGeneratorModule } from "../code-generator/code-generator.module";

@Module({
  imports: [CodeGeneratorModule],
  controllers: [NotificationController],
  providers: [NotificationService],
})
export class NotificationModule {}
