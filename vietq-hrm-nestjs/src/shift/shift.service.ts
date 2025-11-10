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

  async update(shift: CreateShiftDto) {
    try {
      const newDataShift = await this.prisma.shift.update({
        where: {
          shiftCode: shift.shiftCode,
        },
        data: shift,
      });
      return { ...newDataShift };
    } catch (error) {
      throw new HttpException("Update shift failed", 500);
    }
  }

  async delete(shiftCode: string) {
    try {
      const newDataShift = await this.prisma.shift.update({
        where: {
          shiftCode: shiftCode,
        },
        data: {
          isActive: "N",
        },
      });
      return { ...newDataShift };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async getListShift() {
    try {
      const shifts = await this.prisma.shift.findMany({
        where: {
          isActive: "Y",
        },
      });
      return [...shifts];
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
