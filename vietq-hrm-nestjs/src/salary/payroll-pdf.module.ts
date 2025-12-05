import { Module } from "@nestjs/common";
import { PayrollPdfService } from "./payroll-pdf.service";

@Module({
  providers: [PayrollPdfService],
  exports: [PayrollPdfService], // 👈 BẮT BUỘC
})
export class PayrollModule {}
