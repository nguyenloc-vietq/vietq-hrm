import 'winston-daily-rotate-file';
import { LoggerService, LogLevel } from '@nestjs/common';
export declare class MyLogger implements LoggerService {
    private logger;
    constructor();
    log(message: string, context: string[]): void;
    error(message: string, context: string[]): void;
    warn(message: string, context: string[]): void;
    debug?(message: string, context: string[]): void;
    verbose?(message: string, context: string[]): void;
    fatal?(message: string, context: string[]): void;
    setLogLevels?(levels: LogLevel[]): void;
}
