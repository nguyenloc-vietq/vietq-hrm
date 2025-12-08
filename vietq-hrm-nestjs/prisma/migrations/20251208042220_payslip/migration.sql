/*
  Warnings:

  - You are about to drop the `tbl_payslip` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE `tbl_payslip`;

-- CreateTable
CREATE TABLE `tbl_user_payslip` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `payrollCode` VARCHAR(191) NOT NULL,
    `payslipFile` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `tbl_user_payslip_userCode_payrollCode_key`(`userCode`, `payrollCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
