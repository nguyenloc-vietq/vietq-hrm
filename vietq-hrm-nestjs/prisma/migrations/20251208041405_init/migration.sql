-- CreateTable
CREATE TABLE `tbl_user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `companyCode` VARCHAR(191) NOT NULL,
    `userCode` VARCHAR(191) NOT NULL,
    `email` VARCHAR(200) NOT NULL,
    `phone` VARCHAR(191) NOT NULL,
    `fullName` VARCHAR(191) NOT NULL,
    `address` VARCHAR(191) NULL,
    `avatar` VARCHAR(191) NULL,
    `passwordHash` VARCHAR(100) NOT NULL,
    `isActive` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_user_userCode_key`(`userCode`),
    UNIQUE INDEX `tbl_user_email_key`(`email`),
    INDEX `tbl_user_companyCode_idx`(`companyCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_user_professional` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `companyCode` VARCHAR(191) NOT NULL,
    `position` VARCHAR(191) NOT NULL,
    `employeeType` VARCHAR(191) NOT NULL,
    `isActive` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_user_professional_userCode_key`(`userCode`),
    INDEX `tbl_user_professional_userCode_idx`(`userCode`),
    INDEX `tbl_user_professional_companyCode_idx`(`companyCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_role_entity` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` ENUM('ADMIN', 'MANAGER', 'STAFF') NOT NULL,
    `desc` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `isActive` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_role_entity_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_permission` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `desc` VARCHAR(191) NULL,
    `isActive` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `nameCode` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_user_role` (
    `userId` INTEGER NOT NULL,
    `roleId` INTEGER NOT NULL,

    INDEX `tbl_user_role_roleId_fkey`(`roleId`),
    PRIMARY KEY (`userId`, `roleId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_role_permission` (
    `permissionId` INTEGER NOT NULL,
    `roleId` INTEGER NOT NULL,

    INDEX `tbl_role_permission_roleId_fkey`(`roleId`),
    PRIMARY KEY (`permissionId`, `roleId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_company_info` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `companyCode` VARCHAR(191) NOT NULL,
    `companyName` VARCHAR(191) NOT NULL,
    `ssid` VARCHAR(191) NULL,
    `address` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_company_info_companyCode_key`(`companyCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_shift` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `shiftCode` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `startTime` VARCHAR(191) NOT NULL,
    `endTime` VARCHAR(191) NOT NULL,
    `allowableDelay` INTEGER NOT NULL DEFAULT 0,
    `isActive` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_shift_shiftCode_key`(`shiftCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_employee_schedule` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `scheduleCode` VARCHAR(191) NOT NULL,
    `payrollCode` VARCHAR(191) NULL,
    `userCode` VARCHAR(191) NOT NULL,
    `shiftCode` VARCHAR(191) NOT NULL,
    `status` ENUM('PRESENT', 'ABSENT', 'LATE', 'NEXT', 'INDAY') NOT NULL DEFAULT 'NEXT',
    `workOn` DATETIME(3) NULL,
    `isActive` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_employee_schedule_scheduleCode_key`(`scheduleCode`),
    INDEX `tbl_employee_schedule_userCode_idx`(`userCode`),
    INDEX `tbl_employee_schedule_shiftCode_idx`(`shiftCode`),
    INDEX `tbl_employee_schedule_payrollCode_idx`(`payrollCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_attendance` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `payrollCode` VARCHAR(191) NOT NULL,
    `totalWorkDay` DECIMAL(10, 2) NOT NULL,
    `overtimeHours` DECIMAL(10, 2) NOT NULL,
    `leaveDays` DECIMAL(10, 2) NULL,
    `month` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `tbl_attendance_userCode_idx`(`userCode`),
    INDEX `tbl_attendance_payrollCode_idx`(`payrollCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_attendance_records` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `payrollCode` VARCHAR(191) NOT NULL,
    `workDay` DATETIME(3) NOT NULL,
    `timeIn` DATETIME(3) NULL,
    `timeOut` DATETIME(3) NULL,
    `status` ENUM('LATE', 'OVERTIME', 'PRESENT', 'ABSENT') NOT NULL,
    `lateMinutes` INTEGER NOT NULL DEFAULT 0,
    `earlyMinutes` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `tbl_attendance_records_userCode_workDay_idx`(`userCode`, `workDay`),
    INDEX `tbl_attendance_records_payrollCode_idx`(`payrollCode`),
    UNIQUE INDEX `tbl_attendance_records_userCode_payrollCode_workDay_key`(`userCode`, `payrollCode`, `workDay`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_payroll` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `payrollCode` VARCHAR(191) NOT NULL,
    `payrollName` VARCHAR(191) NOT NULL,
    `companyCode` VARCHAR(191) NOT NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `paymentDate` DATETIME(3) NULL,
    `isLocked` VARCHAR(1) NOT NULL DEFAULT 'Y',
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_payroll_payrollCode_key`(`payrollCode`),
    UNIQUE INDEX `tbl_payroll_payrollName_key`(`payrollName`),
    INDEX `tbl_payroll_companyCode_idx`(`companyCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_salary_config` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `unitCode` VARCHAR(191) NULL,
    `baseSalary` DECIMAL(14, 2) NOT NULL,
    `overtimeRate` DECIMAL(6, 3) NOT NULL DEFAULT 1.500,
    `otNightRate` DECIMAL(6, 3) NULL,
    `nightRate` DECIMAL(6, 3) NULL,
    `lateRate` DECIMAL(6, 3) NULL,
    `earlyRate` DECIMAL(6, 3) NULL,
    `effectiveDate` DATETIME(3) NULL,
    `expireDate` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_salary_config_unitCode_key`(`unitCode`),
    INDEX `tbl_salary_config_userCode_idx`(`userCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_salary` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `salaryCode` VARCHAR(191) NOT NULL,
    `payrollCode` VARCHAR(191) NOT NULL,
    `userCode` VARCHAR(191) NOT NULL,
    `monthDate` DATETIME(3) NULL,
    `baseSalary` DECIMAL(14, 2) NOT NULL,
    `allowance` DECIMAL(14, 2) NULL,
    `overtimeHours` DECIMAL(10, 2) NULL,
    `totalWorkDay` DECIMAL(10, 2) NULL,
    `grossSalary` DECIMAL(14, 2) NULL,
    `netSalary` DECIMAL(14, 2) NULL,
    `tax` DECIMAL(14, 2) NULL,
    `insurance` DECIMAL(14, 2) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_salary_salaryCode_key`(`salaryCode`),
    INDEX `tbl_salary_userCode_idx`(`userCode`),
    INDEX `tbl_salary_payrollCode_idx`(`payrollCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_notification` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `notificationCode` VARCHAR(191) NOT NULL,
    `notificationType` VARCHAR(191) NOT NULL,
    `title` LONGTEXT NOT NULL,
    `body` LONGTEXT NOT NULL,
    `targetType` ENUM('SINGLE', 'ALL', 'STAFF') NOT NULL,
    `targetValue` VARCHAR(191) NULL,
    `typeSystem` ENUM('SHIFT_REMINDER', 'EVENT', 'SYSTEM_UPDATE', 'SHIFT_REMIND') NULL,
    `scheduleTime` DATETIME(3) NULL,
    `openSent` INTEGER NULL,
    `isSent` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    UNIQUE INDEX `tbl_notification_notificationCode_key`(`notificationCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_template_notification` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `templateCode` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `bodyTemplate` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `variables` JSON NULL,
    `type` VARCHAR(191) NOT NULL,
    `dataSourceName` JSON NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_template_notification_templateCode_key`(`templateCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_user_notification` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `notificationCode` VARCHAR(191) NOT NULL,
    `isRead` BOOLEAN NOT NULL DEFAULT false,
    `readAt` DATETIME(3) NULL,
    `receivedAt` DATETIME(3) NULL,
    `note` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `tbl_user_notification_userCode_idx`(`userCode`),
    INDEX `tbl_user_notification_notificationCode_idx`(`notificationCode`),
    UNIQUE INDEX `tbl_user_notification_userCode_notificationCode_key`(`userCode`, `notificationCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_user_devices` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `platform` ENUM('android', 'ios') NOT NULL,
    `userCode` VARCHAR(191) NOT NULL,
    `deviceId` VARCHAR(191) NOT NULL,
    `fcmToken` VARCHAR(191) NULL,
    `appVersion` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `lastActive` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_user_devices_userCode_key`(`userCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_data_source` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `dataSourceCode` VARCHAR(191) NOT NULL,
    `tableName` VARCHAR(191) NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_data_source_dataSourceCode_key`(`dataSourceCode`),
    UNIQUE INDEX `tbl_data_source_tableName_key`(`tableName`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_data_sourceItems` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `dataSourceCode` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `content` VARCHAR(191) NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `tbl_data_sourceItems_dataSourceCode_idx`(`dataSourceCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_payroll_config` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `companyCode` VARCHAR(191) NOT NULL,
    `totalDay` INTEGER NOT NULL DEFAULT 24,
    `cycleType` VARCHAR(191) NOT NULL DEFAULT 'MONTHLY',
    `startDay` INTEGER NOT NULL,
    `endDay` INTEGER NOT NULL,
    `paymentDelayDays` INTEGER NOT NULL DEFAULT 5,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_payroll_config_companyCode_key`(`companyCode`),
    UNIQUE INDEX `tbl_payroll_config_totalDay_key`(`totalDay`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_payslip` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `payrollCode` VARCHAR(191) NOT NULL,
    `payslipFile` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_payslip_userCode_payrollCode_key`(`userCode`, `payrollCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_UserRoles` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_UserRoles_AB_unique`(`A`, `B`),
    INDEX `_UserRoles_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_RolePermissions` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_RolePermissions_AB_unique`(`A`, `B`),
    INDEX `_RolePermissions_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_CompanyToSalary` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_CompanyToSalary_AB_unique`(`A`, `B`),
    INDEX `_CompanyToSalary_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_CompanyToSalaryConfig` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_CompanyToSalaryConfig_AB_unique`(`A`, `B`),
    INDEX `_CompanyToSalaryConfig_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_AttendanceToAttendanceRecord` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_AttendanceToAttendanceRecord_AB_unique`(`A`, `B`),
    INDEX `_AttendanceToAttendanceRecord_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_PayrollToPayrollConfig` (
    `A` INTEGER NOT NULL,
    `B` INTEGER NOT NULL,

    UNIQUE INDEX `_PayrollToPayrollConfig_AB_unique`(`A`, `B`),
    INDEX `_PayrollToPayrollConfig_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `tbl_user` ADD CONSTRAINT `tbl_user_companyCode_fkey` FOREIGN KEY (`companyCode`) REFERENCES `tbl_company_info`(`companyCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_professional` ADD CONSTRAINT `tbl_user_professional_companyCode_fkey` FOREIGN KEY (`companyCode`) REFERENCES `tbl_company_info`(`companyCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_professional` ADD CONSTRAINT `tbl_user_professional_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_role` ADD CONSTRAINT `tbl_user_role_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `tbl_role_entity`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_role` ADD CONSTRAINT `tbl_user_role_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `tbl_user`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_role_permission` ADD CONSTRAINT `tbl_role_permission_permissionId_fkey` FOREIGN KEY (`permissionId`) REFERENCES `tbl_permission`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_role_permission` ADD CONSTRAINT `tbl_role_permission_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `tbl_role_entity`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_employee_schedule` ADD CONSTRAINT `tbl_employee_schedule_payrollCode_fkey` FOREIGN KEY (`payrollCode`) REFERENCES `tbl_payroll`(`payrollCode`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_employee_schedule` ADD CONSTRAINT `tbl_employee_schedule_shiftCode_fkey` FOREIGN KEY (`shiftCode`) REFERENCES `tbl_shift`(`shiftCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_employee_schedule` ADD CONSTRAINT `tbl_employee_schedule_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_attendance` ADD CONSTRAINT `tbl_attendance_payrollCode_fkey` FOREIGN KEY (`payrollCode`) REFERENCES `tbl_payroll`(`payrollCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_attendance` ADD CONSTRAINT `tbl_attendance_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_attendance_records` ADD CONSTRAINT `tbl_attendance_records_payrollCode_fkey` FOREIGN KEY (`payrollCode`) REFERENCES `tbl_payroll`(`payrollCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_attendance_records` ADD CONSTRAINT `tbl_attendance_records_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_payroll` ADD CONSTRAINT `tbl_payroll_companyCode_fkey` FOREIGN KEY (`companyCode`) REFERENCES `tbl_company_info`(`companyCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_salary_config` ADD CONSTRAINT `tbl_salary_config_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_salary` ADD CONSTRAINT `tbl_salary_payrollCode_fkey` FOREIGN KEY (`payrollCode`) REFERENCES `tbl_payroll`(`payrollCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_salary` ADD CONSTRAINT `tbl_salary_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_notification` ADD CONSTRAINT `tbl_user_notification_notificationCode_fkey` FOREIGN KEY (`notificationCode`) REFERENCES `tbl_notification`(`notificationCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_notification` ADD CONSTRAINT `tbl_user_notification_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_user_devices` ADD CONSTRAINT `tbl_user_devices_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_data_sourceItems` ADD CONSTRAINT `tbl_data_sourceItems_dataSourceCode_fkey` FOREIGN KEY (`dataSourceCode`) REFERENCES `tbl_data_source`(`dataSourceCode`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_payroll_config` ADD CONSTRAINT `tbl_payroll_config_companyCode_fkey` FOREIGN KEY (`companyCode`) REFERENCES `tbl_company_info`(`companyCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_UserRoles` ADD CONSTRAINT `_UserRoles_A_fkey` FOREIGN KEY (`A`) REFERENCES `tbl_role_entity`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_UserRoles` ADD CONSTRAINT `_UserRoles_B_fkey` FOREIGN KEY (`B`) REFERENCES `tbl_user`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_RolePermissions` ADD CONSTRAINT `_RolePermissions_A_fkey` FOREIGN KEY (`A`) REFERENCES `tbl_permission`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_RolePermissions` ADD CONSTRAINT `_RolePermissions_B_fkey` FOREIGN KEY (`B`) REFERENCES `tbl_role_entity`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_CompanyToSalary` ADD CONSTRAINT `_CompanyToSalary_A_fkey` FOREIGN KEY (`A`) REFERENCES `tbl_company_info`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_CompanyToSalary` ADD CONSTRAINT `_CompanyToSalary_B_fkey` FOREIGN KEY (`B`) REFERENCES `tbl_salary`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_CompanyToSalaryConfig` ADD CONSTRAINT `_CompanyToSalaryConfig_A_fkey` FOREIGN KEY (`A`) REFERENCES `tbl_company_info`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_CompanyToSalaryConfig` ADD CONSTRAINT `_CompanyToSalaryConfig_B_fkey` FOREIGN KEY (`B`) REFERENCES `tbl_salary_config`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_AttendanceToAttendanceRecord` ADD CONSTRAINT `_AttendanceToAttendanceRecord_A_fkey` FOREIGN KEY (`A`) REFERENCES `tbl_attendance`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_AttendanceToAttendanceRecord` ADD CONSTRAINT `_AttendanceToAttendanceRecord_B_fkey` FOREIGN KEY (`B`) REFERENCES `tbl_attendance_records`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_PayrollToPayrollConfig` ADD CONSTRAINT `_PayrollToPayrollConfig_A_fkey` FOREIGN KEY (`A`) REFERENCES `tbl_payroll`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_PayrollToPayrollConfig` ADD CONSTRAINT `_PayrollToPayrollConfig_B_fkey` FOREIGN KEY (`B`) REFERENCES `tbl_payroll_config`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
