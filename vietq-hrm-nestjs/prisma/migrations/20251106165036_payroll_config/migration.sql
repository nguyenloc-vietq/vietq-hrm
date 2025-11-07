-- CreateTable
CREATE TABLE "tbl_payroll_config" (
    "id" SERIAL NOT NULL,
    "companyId" INTEGER NOT NULL,
    "cycleType" TEXT NOT NULL DEFAULT 'MONTHLY',
    "startDay" INTEGER NOT NULL,
    "endDay" INTEGER NOT NULL,
    "paymentDelayDays" INTEGER NOT NULL DEFAULT 5,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_payroll_config_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_PayrollToPayrollConfig" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_PayrollToPayrollConfig_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE INDEX "_PayrollToPayrollConfig_B_index" ON "_PayrollToPayrollConfig"("B");

-- AddForeignKey
ALTER TABLE "tbl_payroll_config" ADD CONSTRAINT "tbl_payroll_config_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "tbl_company_info"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PayrollToPayrollConfig" ADD CONSTRAINT "_PayrollToPayrollConfig_A_fkey" FOREIGN KEY ("A") REFERENCES "tbl_payroll"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PayrollToPayrollConfig" ADD CONSTRAINT "_PayrollToPayrollConfig_B_fkey" FOREIGN KEY ("B") REFERENCES "tbl_payroll_config"("id") ON DELETE CASCADE ON UPDATE CASCADE;
