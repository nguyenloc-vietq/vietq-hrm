import { ConsoleLogger } from "@nestjs/common";
export declare class MyLoggerDev extends ConsoleLogger {
    log(message: unknown, context?: string): void;
}
