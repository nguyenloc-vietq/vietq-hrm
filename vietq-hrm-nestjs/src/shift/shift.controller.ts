import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  ValidationPipe,
  Put,
} from "@nestjs/common";
import { ShiftService } from "./shift.service";

// import { PermissionRequired, PermitAll } from "../common/custom-decorator";
import { ResponseDataSuccess } from "../global/globalClass";
import { CreateShiftDto } from "./dto/create-shift.dto";
import { PermissionRequired } from "src/common/custom-decorator";

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

  @Get("get-list-shift")
  // @PermissionRequired("READ_SHIFT")
  async getListShift(): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.shiftService.getListShift(),
      200,
      "get list shift success",
    );
  }

  @Get(":shiftCode")
  async getShiftByCode(
    @Param("shiftCode") shiftCode: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.shiftService.getShiftByCode(shiftCode),
      200,
      "get shift success",
    );
  }
  //edit shift
  @Put("update")
  @PermissionRequired("UPDATE_SHIFT")
  async update(
    @Body(
      new ValidationPipe({
        transform: true,
      }),
    )
    shift: CreateShiftDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.shiftService.update(shift),
      200,
      "update shift success",
    );
  }

  @Delete("delete")
  @PermissionRequired("DELETE_SHIFT")
  async delete(
    @Body() shift: CreateShiftDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.shiftService.delete(shift.shiftCode),
      200,
      "update shift success",
    );
  }
}
