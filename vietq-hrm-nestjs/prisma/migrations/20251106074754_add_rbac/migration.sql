-- CreateTable
CREATE TABLE "tbl_user_role" (
    "userId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,

    CONSTRAINT "tbl_user_role_pkey" PRIMARY KEY ("userId","roleId")
);

-- CreateTable
CREATE TABLE "tbl_role_permission" (
    "permissionId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,

    CONSTRAINT "tbl_role_permission_pkey" PRIMARY KEY ("permissionId","roleId")
);

-- AddForeignKey
ALTER TABLE "tbl_user_role" ADD CONSTRAINT "tbl_user_role_userId_fkey" FOREIGN KEY ("userId") REFERENCES "tbl_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_user_role" ADD CONSTRAINT "tbl_user_role_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "tbl_role_entity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_role_permission" ADD CONSTRAINT "tbl_role_permission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "tbl_permission"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tbl_role_permission" ADD CONSTRAINT "tbl_role_permission_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "tbl_role_entity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
