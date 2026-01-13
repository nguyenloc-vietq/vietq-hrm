import {
  Body,
  Controller,
  Get,
  Post,
  Req,
  ValidationPipe,
} from "@nestjs/common";
import { RegistrationService } from "./registration.service";
import { ResponseDataSuccess } from "src/global/globalClass";
import express from "express";
import { ApproveRegistrationDto } from "./dto/approve-registration.dto";
import { CreateRegistrationDto } from "./dto/create-registration.dto";

@Controller("registration")
export class RegistrationController {
  constructor(private readonly registrationService: RegistrationService) {}

  @Get("list-registrations")
  async listApplications(
    @Req() req: express.Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.listApplications(req),
      200,
      "Get list registrations successfully",
    );
  }
  @Get("admin-list-registrations")
  async adminListApplications(
    @Req() req: express.Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.adminListApplications(req),
      200,
      "Get list registrations successfully",
    );
  }
  @Get("list-approvals")
  async listApprovals(
    @Req() req: express.Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.listApprovals(req),
      200,
      "Get list approvals successfully",
    );
  }

  @Get("list-history-approvals")
  async listHistoryApp(
    @Req() req: express.Request,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.listHistoryApprovals(req),
      200,
      "Get list history approvals successfully",
    );
  }

  @Post("approve")
  async approveRegistration(
    @Req() req: express.Request,
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    )
    approveRegistration: ApproveRegistrationDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.approveRegistration(
        req,
        approveRegistration,
      ),
      200,
      "Approve registration successfully",
    );
  }
  @Post("reject")
  async rejectRegistration(
    @Req() req: express.Request,
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    )
    rejectRegistration: ApproveRegistrationDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.rejectRegistration(
        req,
        rejectRegistration,
      ),
      200,
      "Reject registration successfully",
    );
  }
  @Post("create")
  async createRegistration(
    @Req() req: express.Request,
    @Body(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    )
    createRegistration: CreateRegistrationDto,
  ): Promise<ResponseDataSuccess<object>> {
    return new ResponseDataSuccess(
      await this.registrationService.createRegistration(
        req,
        createRegistration,
      ),
      200,
      "Create registration successfully",
    );
  }
}
