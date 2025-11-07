import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ValidationPipe,
} from "@nestjs/common";
import { ShiftService } from "./shift.service";

// import { PermissionRequired, PermitAll } from "../common/custom-decorator";
import { ResponseDataSuccess } from "../global/globalClass";
import { CreateShiftDto } from "./dto/create-shift.dto";

@Controller("shift")
export class ShiftController {
  constructor(private readonly shiftService: ShiftService) {}
  @Post("create")
  async create(
    @Body() shift: CreateShiftDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.shiftService.create(shift),
      200,
      "create shift success",
    );
  }
}
