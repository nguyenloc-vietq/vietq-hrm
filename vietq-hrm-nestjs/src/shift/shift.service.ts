import { HttpException, Injectable } from "@nestjs/common";
import { CreateShiftDto } from "./dto/create-shift.dto";
import { UpdateShiftDto } from "./dto/update-shift.dto";
import { DatabaseService } from "../database/database.service";

@Injectable()
export class ShiftService {
  constructor(private readonly prisma: DatabaseService) {}

  async create(shift: CreateShiftDto) {
    try {
      const newDataShift = await this.prisma.shift.create({
        data: shift,
      });
      return { ...newDataShift };
    } catch (error) {
      throw new HttpException("Create shift failed", 500);
    }
  }
}
