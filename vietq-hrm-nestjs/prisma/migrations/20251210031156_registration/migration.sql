-- CreateTable
CREATE TABLE `RegistrationForm` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userCode` VARCHAR(191) NOT NULL,
    `registrationCode` VARCHAR(191) NOT NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `RegistrationForm_userCode_key`(`userCode`),
    UNIQUE INDEX `RegistrationForm_registrationCode_key`(`registrationCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RegistrationApproval` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `registrationCode` VARCHAR(191) NOT NULL,
    `userApproverCode` VARCHAR(191) NOT NULL,
    `prevStatus` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL,
    `newStatus` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL,

    UNIQUE INDEX `RegistrationApproval_registrationCode_key`(`registrationCode`),
    UNIQUE INDEX `RegistrationApproval_userApproverCode_key`(`userApproverCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `RegistrationForm` ADD CONSTRAINT `RegistrationForm_userCode_fkey` FOREIGN KEY (`userCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RegistrationApproval` ADD CONSTRAINT `RegistrationApproval_registrationCode_fkey` FOREIGN KEY (`registrationCode`) REFERENCES `RegistrationForm`(`registrationCode`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RegistrationApproval` ADD CONSTRAINT `RegistrationApproval_userApproverCode_fkey` FOREIGN KEY (`userApproverCode`) REFERENCES `tbl_user`(`userCode`) ON DELETE RESTRICT ON UPDATE CASCADE;
