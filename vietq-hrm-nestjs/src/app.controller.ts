import { Controller, Get, Head, HttpCode, HttpStatus } from "@nestjs/common";

import { AppService } from "./app.service";
import { PermitAll } from "./common/custom-decorator";

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get("health")
  @PermitAll()
  getHealth() {
    return {
      status: "OK",
      timestamp: new Date().toISOString(),
    };
  }

  @Head("health")
  @PermitAll()
  @HttpCode(HttpStatus.OK)
  getHealthHead() {
    return "OK";
  }
}
