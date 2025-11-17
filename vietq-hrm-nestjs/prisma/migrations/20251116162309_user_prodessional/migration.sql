-- AlterTable
ALTER TABLE "tbl_company_info" ADD COLUMN     "address" TEXT;

-- CreateTable
CREATE TABLE "tbl_user_professional" (
    "id" SERIAL NOT NULL,
    "userCode" TEXT NOT NULL,
    "companyCode" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "employeeType" TEXT NOT NULL,
    "isActive" VARCHAR(1) NOT NULL DEFAULT 'Y',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tbl_user_professional_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tbl_user_professional_userCode_key" ON "tbl_user_professional"("userCode");

-- CreateIndex
CREATE INDEX "tbl_user_professional_userCode_idx" ON "tbl_user_professional"("userCode");

-- CreateIndex
CREATE INDEX "tbl_user_professional_companyCode_idx" ON "tbl_user_professional"("companyCode");

-- AddForeignKey
ALTER TABLE "tbl_user_professional" ADD CONSTRAINT "tbl_user_professional_userCode_fkey" FOREIGN KEY ("userCode") REFERENCES "tbl_user"("userCode") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_professional" ADD CONSTRAINT "tbl_user_professional_companyCode_fkey" FOREIGN KEY ("companyCode") REFERENCES "tbl_company_info"("companyCode") ON DELETE CASCADE ON UPDATE CASCADE;
