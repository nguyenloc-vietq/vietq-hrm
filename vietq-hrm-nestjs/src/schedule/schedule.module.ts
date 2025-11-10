import { Module } from "@nestjs/common";
import { ScheduleService } from "./schedule.service";
import { ScheduleController } from "./schedule.controller";
import { CodeGeneratorModule } from "src/code-generator/code-generator.module";

@Module({
  imports: [CodeGeneratorModule],
  controllers: [ScheduleController],
  providers: [ScheduleService],
})
export class ScheduleModule {}
