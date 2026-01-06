import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Query,
  Res,
  ValidationPipe,
} from "@nestjs/common";

import { CreateSalaryDto } from "./dto/create-salary.dto";
import { SalaryService } from "./salary.service";
import { UpdateSalaryDto } from "./dto/update-salary.dto";
import { ResponseDataSuccess } from "src/global/globalClass";
import { ReportPayrollDto } from "./dto/reportPayroll-salary.dto";

@Controller("salary")
export class SalaryController {
  constructor(private readonly salaryService: SalaryService) {}

  @Post("create")
  async create(
    @Body(ValidationPipe) createDataSalaryUser: CreateSalaryDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.salaryService.createSalaryUser(createDataSalaryUser),
      200,
      "create salary is successfully",
    );
  }

  @Get("salary-list-user")
  async getSalaryListUser(): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.salaryService.getSalaryListUser(),
      200,
      "get list user is successfully",
    );
  }

  @Get("payslip-list")
  async getPayslipList(
    @Query("month") month?: string,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.salaryService.getPayslipList(month),
      200,
      "get payslip list is successfully",
    );
  }

  @Get("report-payroll")
  async repotPayroll(
    @Body(ValidationPipe) reportPayroll: ReportPayrollDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.salaryService.reportPayroll(reportPayroll),
      200,
      "report payroll is successfully",
    );
  }
}
