/*
  Warnings:

  - You are about to drop the column `companyId` on the `tbl_payroll_config` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[companyCode]` on the table `tbl_payroll_config` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `companyCode` to the `tbl_payroll_config` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "tbl_payroll_config" DROP CONSTRAINT "tbl_payroll_config_companyId_fkey";

-- AlterTable
ALTER TABLE "tbl_payroll_config" DROP COLUMN "companyId",
ADD COLUMN     "companyCode" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "tbl_payroll_config_companyCode_key" ON "tbl_payroll_config"("companyCode");

-- AddForeignKey
ALTER TABLE "tbl_payroll_config" ADD CONSTRAINT "tbl_payroll_config_companyCode_fkey" FOREIGN KEY ("companyCode") REFERENCES "tbl_company_info"("companyCode") ON DELETE RESTRICT ON UPDATE CASCADE;
