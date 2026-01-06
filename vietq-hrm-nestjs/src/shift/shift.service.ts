import { HttpException, Injectable } from "@nestjs/common";
import { CreateShiftDto } from "./dto/create-shift.dto";
import { UpdateShiftDto } from "./dto/update-shift.dto";
import { DatabaseService } from "../database/database.service";
import { CodeGeneratorService } from "src/code-generator/code-generator.service";

@Injectable()
export class ShiftService {
  constructor(
    private readonly prisma: DatabaseService,
    private codeGen: CodeGeneratorService,
  ) {}

  async create(shift: CreateShiftDto) {
    try {
      const shiftCode = await this.codeGen.generateCode(
        this.prisma.shift,
        "SC",
        {
          field: "shiftCode",
        },
      );
      console.log("[==================>", shiftCode);
      const newDataShift = await this.prisma.shift.create({
        data: {
          ...shift,
          shiftCode,
        },
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

  async getShiftByCode(shiftCode: string) {
    try {
      const shift = await this.prisma.shift.findUnique({
        where: {
          shiftCode,
          isActive: "Y",
        },
      });

      if (!shift) {
        throw new HttpException("Shift not found", 404);
      }

      return shift;
    } catch (error) {
      throw new HttpException(error.message, error.status || 500);
    }
  }
}
