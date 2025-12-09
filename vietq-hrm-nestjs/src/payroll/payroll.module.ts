import { Module } from "@nestjs/common";
import { PayrollService } from "./payroll.service";
import { PayrollController } from "./payroll.controller";
import { DatabaseService } from "src/database/database.service";
import { CodeGeneratorModule } from "src/code-generator/code-generator.module";

@Module({
  imports: [CodeGeneratorModule],
  controllers: [PayrollController],
  providers: [PayrollService],
})
export class PayrollModule {}
