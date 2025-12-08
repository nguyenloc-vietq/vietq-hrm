import { CodeGeneratorModule } from "src/code-generator/code-generator.module";
import { FirebaseModule } from "src/firebase/firebase.module";
import { Module } from "@nestjs/common";
import { PayrollModule } from "./payroll-pdf.module";
import { SalaryController } from "./salary.controller";
import { SalaryService } from "./salary.service";

@Module({
  imports: [PayrollModule, FirebaseModule, CodeGeneratorModule],
  controllers: [SalaryController],
  providers: [SalaryService],
})
export class SalaryModule {}
