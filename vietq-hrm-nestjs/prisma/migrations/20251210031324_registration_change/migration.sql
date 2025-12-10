/*
  Warnings:

  - You are about to drop the `RegistrationApproval` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `RegistrationForm` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `RegistrationApproval` DROP FOREIGN KEY `RegistrationApproval_registrationCode_fkey`;

-- DropForeignKey
ALTER TABLE `RegistrationApproval` DROP FOREIGN KEY `RegistrationApproval_userApproverCode_fkey`;

-- DropForeignKey
ALTER TABLE `RegistrationForm` DROP FOREIGN KEY `RegistrationForm_userCode_fkey`;

-- DropTable
DROP TABLE `RegistrationApproval`;

-- DropTable
DROP TABLE `RegistrationForm`;

-- CreateTable
CREATE TABLE `tbl_registration_form` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `registrationCode` VARCHAR(191) NOT NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_registration_form_userCode_key`(`userCode`),
    UNIQUE INDEX `tbl_registration_form_registrationCode_key`(`registrationCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tbl_registration_approval` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `registrationCode` VARCHAR(191) NOT NULL,
    `userApproverCode` VARCHAR(191) NOT NULL,
    `prevStatus` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL,
    `newStatus` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL,

    UNIQUE INDEX `tbl_registration_approval_registrationCode_key`(`registrationCode`),
    UNIQUE INDEX `tbl_registration_approval_userApproverCode_key`(`userApproverCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `tbl_registration_form` ADD CONSTRAINT `tbl_registration_form_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_registration_approval` ADD CONSTRAINT `tbl_registration_approval_registrationCode_fkey` FOREIGN KEY (`registrationCode`) REFERENCES `tbl_registration_form`(`registrationCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `tbl_registration_approval` ADD CONSTRAINT `tbl_registration_approval_userApproverCode_fkey` FOREIGN KEY (`userApproverCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE RESTRICT ON UPDATE CASCADE;
