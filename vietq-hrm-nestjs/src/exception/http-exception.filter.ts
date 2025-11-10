/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
} from "@nestjs/common";
import { error } from "console";
import { MyLogger } from "src/logger/my.logger";
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  private logger = new MyLogger();
  catch(exception: any, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();
    const status =
      exception instanceof HttpException ? exception.getStatus() : 500;
    this.logger.error(exception.message, [exception.stack]);
    // this.logger.log(exception.message, [exception.stack]);
    const errorResponse =
      exception instanceof HttpException ? exception.getResponse() : null;
    const message =
      (errorResponse as any)?.message ||
      exception.message ||
      "Internal server error";
    if (process.env.NODE_ENV === "dev") {
      response.status(status).json({
        error: true,
        statusCode: status,
        timestamp: new Date().toISOString(),
        path: request.url,
        message,
        stack: exception.stack,
      });
    } else {
      response.status(status).json({
        error: true,
        statusCode: status,
        timestamp: new Date().toISOString(),
        path: request.url,
        message,
      });
    }
  }
}
