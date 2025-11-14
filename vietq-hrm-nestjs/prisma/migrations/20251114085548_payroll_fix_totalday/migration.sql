/*
  Warnings:

  - A unique constraint covering the columns `[totalDay]` on the table `tbl_payroll_config` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "tbl_payroll_config" ADD COLUMN     "totalDay" INTEGER NOT NULL DEFAULT 24;

-- CreateIndex
CREATE UNIQUE INDEX "tbl_payroll_config_totalDay_key" ON "tbl_payroll_config"("totalDay");
