import { Module } from "@nestjs/common";
import { ShiftService } from "./shift.service";
import { ShiftController } from "./shift.controller";
import { CodeGeneratorModule } from "src/code-generator/code-generator.module";

@Module({
  imports: [CodeGeneratorModule],
  controllers: [ShiftController],
  providers: [ShiftService],
})
export class ShiftModule {}
