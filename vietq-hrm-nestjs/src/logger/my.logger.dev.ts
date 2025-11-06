import { ConsoleLogger } from "@nestjs/common";

export class MyLoggerDev extends ConsoleLogger {
  log(message: unknown, context?: string): void {
    console.log(`[${context}] | `, message);
  }
}
