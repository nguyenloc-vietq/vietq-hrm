import { Module } from "@nestjs/common";
import { PayrollModule } from "./payroll-pdf.module";
import { SalaryController } from "./salary.controller";
import { SalaryService } from "./salary.service";

@Module({
  imports: [PayrollModule],
  controllers: [SalaryController],
  providers: [SalaryService],
})
export class SalaryModule {}
