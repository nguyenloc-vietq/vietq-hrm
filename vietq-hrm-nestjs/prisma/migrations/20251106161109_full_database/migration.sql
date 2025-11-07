/*
  Warnings:

  - Added the required column `nameCode` to the `tbl_permission` table without a default value. This is not possible if the table is not empty.
  - Made the column `companyCode` on table `tbl_user` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "AttendanceStatus" AS ENUM ('LATE', 'OVERTIME', 'PRESENT', 'ABSENT');

-- CreateEnum
CREATE TYPE "NotificationTargetType" AS ENUM ('SINGLE', 'ALL', 'STAFF');

-- CreateEnum
CREATE TYPE "SystemNotificationType" AS ENUM ('SHIFT_REMINDER', 'EVENT', 'SYSTEM_UPDATE', 'SHIFT_REMIND');

-- CreateEnum
CREATE TYPE "DevicePlatform" AS ENUM ('android', 'ios');

-- AlterTable
ALTER TABLE "tbl_permission" ADD COLUMN     "nameCode" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "tbl_user" ALTER COLUMN "companyCode" SET NOT NULL;

-- CreateTable
CREATE TABLE "tbl_company_info" (
    "id" SERIAL NOT NULL,
    "companyCode" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "ssid" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_company_info_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_shift" (
    "id" SERIAL NOT NULL,
    "shiftCode" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "allowableDelay" INTEGER NOT NULL DEFAULT 0,
    "isActive" VARCHAR(1) NOT NULL DEFAULT 'Y',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_shift_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_employee_schedule" (
    "id" SERIAL NOT NULL,
    "scheduleCode" TEXT NOT NULL,
    "payrollCode" TEXT,
    "userId" INTEGER NOT NULL,
    "shiftId" INTEGER NOT NULL,
    "workOn" TIMESTAMP(3),
    "isActive" VARCHAR(1) NOT NULL DEFAULT 'Y',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_employee_schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_attendance" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "payrollCode" TEXT NOT NULL,
    "totalWorkDay" DECIMAL(10,2) NOT NULL,
    "overtimeHours" DECIMAL(10,2) NOT NULL,
    "leaveDays" DECIMAL(10,2),
    "month" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_attendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_attendance_records" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "payrollCode" TEXT NOT NULL,
    "workDay" TIMESTAMP(3) NOT NULL,
    "timeIn" TIMESTAMP(3),
    "timeOut" TIMESTAMP(3),
    "status" "AttendanceStatus" NOT NULL,
    "lateMinutes" INTEGER NOT NULL DEFAULT 0,
    "earlyMinutes" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_attendance_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_payroll" (
    "id" SERIAL NOT NULL,
    "payrollCode" TEXT NOT NULL,
    "payrollName" TEXT NOT NULL,
    "companyId" INTEGER NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "paymentDate" TIMESTAMP(3),
    "isLocked" VARCHAR(1) NOT NULL DEFAULT 'Y',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_payroll_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_salary_config" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "unitCode" TEXT,
    "baseSalary" DECIMAL(14,2) NOT NULL,
    "overtimeRate" DECIMAL(6,3) NOT NULL DEFAULT 1.5,
    "otNightRate" DECIMAL(6,3),
    "nightRate" DECIMAL(6,3),
    "lateRate" DECIMAL(6,3),
    "earlyRate" DECIMAL(6,3),
    "effectiveDate" TIMESTAMP(3),
    "expireDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_salary_config_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_salary" (
    "id" SERIAL NOT NULL,
    "salaryCode" TEXT NOT NULL,
    "payrollCode" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "monthDate" TIMESTAMP(3),
    "baseSalary" DECIMAL(14,2) NOT NULL,
    "allowance" DECIMAL(14,2),
    "overtimeHours" DECIMAL(10,2),
    "totalWorkDay" DECIMAL(10,2),
    "grossSalary" DECIMAL(14,2),
    "netSalary" DECIMAL(14,2),
    "tax" DECIMAL(14,2),
    "insurance" DECIMAL(14,2),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_salary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_notification" (
    "id" SERIAL NOT NULL,
    "notificationCode" TEXT NOT NULL,
    "notificationType" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "targetType" "NotificationTargetType" NOT NULL,
    "targetValue" TEXT,
    "typeSystem" "SystemNotificationType",
    "scheduleTime" TIMESTAMP(3),
    "openSent" INTEGER,
    "isSent" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_template_notification" (
    "id" SERIAL NOT NULL,
    "templateCode" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "bodyTemplate" TEXT NOT NULL,
    "description" TEXT,
    "variables" JSONB,
    "type" TEXT NOT NULL,
    "dataSourceName" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_template_notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_user_notification" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "notificationCode" TEXT NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "readAt" TIMESTAMP(3),
    "receivedAt" TIMESTAMP(3),
    "note" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_user_notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_user_devices" (
    "id" SERIAL NOT NULL,
    "platform" "DevicePlatform" NOT NULL,
    "userId" INTEGER NOT NULL,
    "deviceId" TEXT NOT NULL,
    "fcmToken" TEXT,
    "appVersion" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastActive" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_user_devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_data_source" (
    "id" SERIAL NOT NULL,
    "dataSourceCode" TEXT NOT NULL,
    "tableName" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_data_source_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_data_sourceItems" (
    "id" SERIAL NOT NULL,
    "dataSourceCode" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_data_sourceItems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CompanyToSalaryConfig" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_CompanyToSalaryConfig_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_CompanyToSalary" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_CompanyToSalary_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateTable
CREATE TABLE "_AttendanceToAttendanceRecord" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_AttendanceToAttendanceRecord_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "tbl_company_info_companyCode_key" ON "tbl_company_info"("companyCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_shift_shiftCode_key" ON "tbl_shift"("shiftCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_employee_schedule_scheduleCode_key" ON "tbl_employee_schedule"("scheduleCode");

-- CreateIndex
CREATE INDEX "tbl_employee_schedule_userId_idx" ON "tbl_employee_schedule"("userId");

-- CreateIndex
CREATE INDEX "tbl_employee_schedule_shiftId_idx" ON "tbl_employee_schedule"("shiftId");

-- CreateIndex
CREATE INDEX "tbl_employee_schedule_payrollCode_idx" ON "tbl_employee_schedule"("payrollCode");

-- CreateIndex
CREATE INDEX "tbl_attendance_userId_idx" ON "tbl_attendance"("userId");

-- CreateIndex
CREATE INDEX "tbl_attendance_payrollCode_idx" ON "tbl_attendance"("payrollCode");

-- CreateIndex
CREATE INDEX "tbl_attendance_records_userId_workDay_idx" ON "tbl_attendance_records"("userId", "workDay");

-- CreateIndex
CREATE INDEX "tbl_attendance_records_payrollCode_idx" ON "tbl_attendance_records"("payrollCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_attendance_records_userId_payrollCode_workDay_key" ON "tbl_attendance_records"("userId", "payrollCode", "workDay");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_payroll_payrollCode_key" ON "tbl_payroll"("payrollCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_payroll_payrollName_key" ON "tbl_payroll"("payrollName");

-- CreateIndex
CREATE INDEX "tbl_payroll_companyId_idx" ON "tbl_payroll"("companyId");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_salary_config_unitCode_key" ON "tbl_salary_config"("unitCode");

-- CreateIndex
CREATE INDEX "tbl_salary_config_userId_idx" ON "tbl_salary_config"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_salary_salaryCode_key" ON "tbl_salary"("salaryCode");

-- CreateIndex
CREATE INDEX "tbl_salary_userId_idx" ON "tbl_salary"("userId");

-- CreateIndex
CREATE INDEX "tbl_salary_payrollCode_idx" ON "tbl_salary"("payrollCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_notification_notificationCode_key" ON "tbl_notification"("notificationCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_template_notification_templateCode_key" ON "tbl_template_notification"("templateCode");

-- CreateIndex
CREATE INDEX "tbl_user_notification_userId_idx" ON "tbl_user_notification"("userId");

-- CreateIndex
CREATE INDEX "tbl_user_notification_notificationCode_idx" ON "tbl_user_notification"("notificationCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_notification_userId_notificationCode_key" ON "tbl_user_notification"("userId", "notificationCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_devices_userId_key" ON "tbl_user_devices"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_data_source_dataSourceCode_key" ON "tbl_data_source"("dataSourceCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_data_source_tableName_key" ON "tbl_data_source"("tableName");

-- CreateIndex
CREATE INDEX "tbl_data_sourceItems_dataSourceCode_idx" ON "tbl_data_sourceItems"("dataSourceCode");

-- CreateIndex
CREATE INDEX "_CompanyToSalaryConfig_B_index" ON "_CompanyToSalaryConfig"("B");

-- CreateIndex
CREATE INDEX "_CompanyToSalary_B_index" ON "_CompanyToSalary"("B");

-- CreateIndex
CREATE INDEX "_AttendanceToAttendanceRecord_B_index" ON "_AttendanceToAttendanceRecord"("B");

-- CreateIndex
CREATE INDEX "tbl_user_companyCode_idx" ON "tbl_user"("companyCode");

-- AddForeignKey
ALTER TABLE "tbl_user" ADD CONSTRAINT "tbl_user_companyCode_fkey" FOREIGN KEY ("companyCode") REFERENCES "tbl_company_info"("companyCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_employee_schedule" ADD CONSTRAINT "tbl_employee_schedule_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_employee_schedule" ADD CONSTRAINT "tbl_employee_schedule_shiftId_fkey" FOREIGN KEY ("shiftId") REFERENCES "tbl_shift"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_employee_schedule" ADD CONSTRAINT "tbl_employee_schedule_payrollCode_fkey" FOREIGN KEY ("payrollCode") REFERENCES "tbl_payroll"("payrollCode") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_attendance" ADD CONSTRAINT "tbl_attendance_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_attendance" ADD CONSTRAINT "tbl_attendance_payrollCode_fkey" FOREIGN KEY ("payrollCode") REFERENCES "tbl_payroll"("payrollCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_attendance_records" ADD CONSTRAINT "tbl_attendance_records_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_attendance_records" ADD CONSTRAINT "tbl_attendance_records_payrollCode_fkey" FOREIGN KEY ("payrollCode") REFERENCES "tbl_payroll"("payrollCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_payroll" ADD CONSTRAINT "tbl_payroll_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "tbl_company_info"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_salary_config" ADD CONSTRAINT "tbl_salary_config_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_salary" ADD CONSTRAINT "tbl_salary_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_salary" ADD CONSTRAINT "tbl_salary_payrollCode_fkey" FOREIGN KEY ("payrollCode") REFERENCES "tbl_payroll"("payrollCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_notification" ADD CONSTRAINT "tbl_user_notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_notification" ADD CONSTRAINT "tbl_user_notification_notificationCode_fkey" FOREIGN KEY ("notificationCode") REFERENCES "tbl_notification"("notificationCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_devices" ADD CONSTRAINT "tbl_user_devices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_data_sourceItems" ADD CONSTRAINT "tbl_data_sourceItems_dataSourceCode_fkey" FOREIGN KEY ("dataSourceCode") REFERENCES "tbl_data_source"("dataSourceCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompanyToSalaryConfig" ADD CONSTRAINT "_CompanyToSalaryConfig_A_fkey" FOREIGN KEY ("A") REFERENCES "tbl_company_info"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompanyToSalaryConfig" ADD CONSTRAINT "_CompanyToSalaryConfig_B_fkey" FOREIGN KEY ("B") REFERENCES "tbl_salary_config"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompanyToSalary" ADD CONSTRAINT "_CompanyToSalary_A_fkey" FOREIGN KEY ("A") REFERENCES "tbl_company_info"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CompanyToSalary" ADD CONSTRAINT "_CompanyToSalary_B_fkey" FOREIGN KEY ("B") REFERENCES "tbl_salary"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AttendanceToAttendanceRecord" ADD CONSTRAINT "_AttendanceToAttendanceRecord_A_fkey" FOREIGN KEY ("A") REFERENCES "tbl_attendance"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AttendanceToAttendanceRecord" ADD CONSTRAINT "_AttendanceToAttendanceRecord_B_fkey" FOREIGN KEY ("B") REFERENCES "tbl_attendance_records"("id") ON DELETE CASCADE ON UPDATE CASCADE;
