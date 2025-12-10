/*
  Warnings:

  - Added the required column `reason` to the `tbl_registration_form` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `tbl_registration_form` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `tbl_registration_form` ADD COLUMN `reason` VARCHAR(191) NOT NULL,
    ADD COLUMN `timeIn` DATETIME(3) NULL,
    ADD COLUMN `timeOut` DATETIME(3) NULL,
    ADD COLUMN `type` ENUM('SICK', 'ANNUAL', 'MEDICAL', 'MATERNITY', 'CHECKIN', 'CHECKOUT', 'LEAVE') NOT NULL;
