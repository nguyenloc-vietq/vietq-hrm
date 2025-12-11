/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Body,
  Controller,
  Get,
  Post,
  Put,
  Req,
  ValidationPipe,
} from "@nestjs/common";
import { PayrollService } from "./payroll.service";
import { ResponseDataSuccess } from "src/global/globalClass";
import express from "express";
import {
  UpdatePayrollConfigDto,
  UpdatePayrollDto,
} from "./dto/update-payroll.dto";
import { CreatePayrollDto } from "./dto/create-payroll.dto";

@Controller("payroll")
export class PayrollController {
  constructor(private readonly payrollService: PayrollService) {}

  @Get("list-payroll")
  async getPayroll(
    @Req() req: express.Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess<object>(
      await this.payrollService.getPayroll(req),
      200,
      "Get list payroll is ResponseDataSuccess",
    );
  }

  @Put("update")
  async updatePayroll(
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    )
    dataUpdate: UpdatePayrollDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess<object>(
      await this.payrollService.updatePayroll(dataUpdate),
      200,
      "Update payroll is ResponseDataSuccess",
    );
  }

  @Post("create")
  async createPayroll(
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    )
    dataCreate: CreatePayrollDto,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess<object>(
      await this.payrollService.createPayroll(dataCreate, req),
      200,
      "Create payroll is ResponseDataSuccess",
    );
  }

  @Get("get-config")
  async getPayrollConfig(
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.payrollService.getPayrollConfig(req),
      200,
      "Get payroll config is ResponseDataSuccess",
    );
  }

  @Put("update-config")
  async updatePayrollConfig(
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    )
    dataUpdate: UpdatePayrollConfigDto,
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess<object>(
      await this.payrollService.updatePayrollConfig(dataUpdate, req),
      200,
      "Update payroll is response data success",
    );
  }

  @Get("list-payslips")
  async getListUserPayroll(
    @Req() req: any,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.payrollService.getListUserPayroll(req),
      200,
      "Get list user payroll is ResponseDataSuccess",
    );
  }
}
