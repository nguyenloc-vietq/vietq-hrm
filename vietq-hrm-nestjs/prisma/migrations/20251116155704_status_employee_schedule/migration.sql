-- CreateEnum
CREATE TYPE "ScheduleStatus" AS ENUM ('PRESENT', 'ABSENT', 'LATE', 'NEXT', 'INDAY');

-- AlterTable
ALTER TABLE "tbl_employee_schedule" ADD COLUMN     "status" "ScheduleStatus" NOT NULL DEFAULT 'NEXT';
