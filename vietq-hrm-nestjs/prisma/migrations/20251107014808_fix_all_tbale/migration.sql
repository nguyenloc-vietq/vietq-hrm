/*
  Warnings:

  - You are about to drop the column `userId` on the `tbl_attendance` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tbl_attendance_records` table. All the data in the column will be lost.
  - You are about to drop the column `shiftId` on the `tbl_employee_schedule` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tbl_employee_schedule` table. All the data in the column will be lost.
  - You are about to drop the column `companyId` on the `tbl_payroll` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tbl_salary` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tbl_salary_config` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tbl_user_devices` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `tbl_user_notification` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[userCode,payrollCode,workDay]` on the table `tbl_attendance_records` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userCode]` on the table `tbl_user_devices` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userCode,notificationCode]` on the table `tbl_user_notification` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userCode` to the `tbl_attendance` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userCode` to the `tbl_attendance_records` table without a default value. This is not possible if the table is not empty.
  - Added the required column `shiftCode` to the `tbl_employee_schedule` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userCode` to the `tbl_employee_schedule` table without a default value. This is not possible if the table is not empty.
  - Added the required column `companyCode` to the `tbl_payroll` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userCode` to the `tbl_salary` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userCode` to the `tbl_salary_config` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userCode` to the `tbl_user_devices` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userCode` to the `tbl_user_notification` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "tbl_attendance" DROP CONSTRAINT "tbl_attendance_userId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_attendance_records" DROP CONSTRAINT "tbl_attendance_records_userId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_employee_schedule" DROP CONSTRAINT "tbl_employee_schedule_shiftId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_employee_schedule" DROP CONSTRAINT "tbl_employee_schedule_userId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_payroll" DROP CONSTRAINT "tbl_payroll_companyId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_salary" DROP CONSTRAINT "tbl_salary_userId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_salary_config" DROP CONSTRAINT "tbl_salary_config_userId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_user_devices" DROP CONSTRAINT "tbl_user_devices_userId_fkey";

-- DropForeignKey
ALTER TABLE "tbl_user_notification" DROP CONSTRAINT "tbl_user_notification_userId_fkey";

-- DropIndex
DROP INDEX "tbl_attendance_userId_idx";

-- DropIndex
DROP INDEX "tbl_attendance_records_userId_payrollCode_workDay_key";

-- DropIndex
DROP INDEX "tbl_attendance_records_userId_workDay_idx";

-- DropIndex
DROP INDEX "tbl_employee_schedule_shiftId_idx";

-- DropIndex
DROP INDEX "tbl_employee_schedule_userId_idx";

-- DropIndex
DROP INDEX "tbl_payroll_companyId_idx";

-- DropIndex
DROP INDEX "tbl_salary_userId_idx";

-- DropIndex
DROP INDEX "tbl_salary_config_userId_idx";

-- DropIndex
DROP INDEX "tbl_user_devices_userId_key";

-- DropIndex
DROP INDEX "tbl_user_notification_userId_idx";

-- DropIndex
DROP INDEX "tbl_user_notification_userId_notificationCode_key";

-- AlterTable
ALTER TABLE "tbl_attendance" DROP COLUMN "userId",
ADD COLUMN     "userCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_attendance_records" DROP COLUMN "userId",
ADD COLUMN     "userCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_employee_schedule" DROP COLUMN "shiftId",
DROP COLUMN "userId",
ADD COLUMN     "shiftCode" TEXT NOT NULL,
ADD COLUMN     "userCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_payroll" DROP COLUMN "companyId",
ADD COLUMN     "companyCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_salary" DROP COLUMN "userId",
ADD COLUMN     "userCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_salary_config" DROP COLUMN "userId",
ADD COLUMN     "userCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_user_devices" DROP COLUMN "userId",
ADD COLUMN     "userCode" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "tbl_user_notification" DROP COLUMN "userId",
ADD COLUMN     "userCode" TEXT NOT NULL;

-- CreateIndex
CREATE INDEX "tbl_attendance_userCode_idx" ON "tbl_attendance"("userCode");

-- CreateIndex
CREATE INDEX "tbl_attendance_records_userCode_workDay_idx" ON "tbl_attendance_records"("userCode", "workDay");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_attendance_records_userCode_payrollCode_workDay_key" ON "tbl_attendance_records"("userCode", "payrollCode", "workDay");

-- CreateIndex
CREATE INDEX "tbl_employee_schedule_userCode_idx" ON "tbl_employee_schedule"("userCode");

-- CreateIndex
CREATE INDEX "tbl_employee_schedule_shiftCode_idx" ON "tbl_employee_schedule"("shiftCode");

-- CreateIndex
CREATE INDEX "tbl_payroll_companyCode_idx" ON "tbl_payroll"("companyCode");

-- CreateIndex
CREATE INDEX "tbl_salary_userCode_idx" ON "tbl_salary"("userCode");

-- CreateIndex
CREATE INDEX "tbl_salary_config_userCode_idx" ON "tbl_salary_config"("userCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_devices_userCode_key" ON "tbl_user_devices"("userCode");

-- CreateIndex
CREATE INDEX "tbl_user_notification_userCode_idx" ON "tbl_user_notification"("userCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_notification_userCode_notificationCode_key" ON "tbl_user_notification"("userCode", "notificationCode");

-- AddForeignKey
ALTER TABLE "tbl_employee_schedule" ADD CONSTRAINT "tbl_employee_schedule_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_employee_schedule" ADD CONSTRAINT "tbl_employee_schedule_shiftCode_fkey" FOREIGN KEY ("shiftCode") REFERENCES "tbl_shift"("shiftCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_attendance" ADD CONSTRAINT "tbl_attendance_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_attendance_records" ADD CONSTRAINT "tbl_attendance_records_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_payroll" ADD CONSTRAINT "tbl_payroll_companyCode_fkey" FOREIGN KEY ("companyCode") REFERENCES "tbl_company_info"("companyCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_salary_config" ADD CONSTRAINT "tbl_salary_config_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_salary" ADD CONSTRAINT "tbl_salary_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_notification" ADD CONSTRAINT "tbl_user_notification_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_devices" ADD CONSTRAINT "tbl_user_devices_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;
