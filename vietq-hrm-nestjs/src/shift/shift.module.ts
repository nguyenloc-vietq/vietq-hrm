import { Module } from "@nestjs/common";
import { ShiftService } from "./shift.service";
import { ShiftController } from "./shift.controller";
import { DatabaseModule } from "../database/database.module";

@Module({
  imports: [DatabaseModule],
  controllers: [ShiftController],
  providers: [ShiftService],
})
export class ShiftModule {}
