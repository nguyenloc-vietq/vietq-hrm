-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'STAFF');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'DELETED');

-- CreateTable
CREATE TABLE "tbl_user" (
    "id" SERIAL NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'STAFF',
    "companyCode" TEXT,
    "userCode" TEXT NOT NULL,
    "email" VARCHAR(200) NOT NULL,
    "phone" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "avatar" TEXT,
    "passwordHash" VARCHAR(100) NOT NULL,
    "isActive" VARCHAR(1) NOT NULL DEFAULT 'Y',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "roleId" INTEGER,

    CONSTRAINT "tbl_user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tbl_role_entity" (
    "id" SERIAL NOT NULL,
    "name" "Role" NOT NULL,
    "desc" TEXT,

    CONSTRAINT "tbl_role_entity_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_userCode_key" ON "tbl_user"("userCode");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_email_key" ON "tbl_user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "tbl_role_entity_name_key" ON "tbl_role_entity"("name");

-- AddForeignKey
ALTER TABLE "tbl_user" ADD CONSTRAINT "tbl_user_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "tbl_role_entity"("id") ON DELETE SET NULL ON UPDATE CASCADE;
