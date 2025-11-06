import { createLogger, format, Logger, transport, transports } from "winston";
import "winston-daily-rotate-file";
import { LoggerService, LogLevel } from "@nestjs/common";
import chalk from "chalk";
import dayjs from "dayjs";

export class MyLogger implements LoggerService {
  private logger: Logger;
  constructor() {
    this.logger = createLogger({
      level: "debug",
      //   format: format.combine(
      //     format.colorize(),
      //     format.timestamp(),
      //     format.simple(),
      //   ),
      transports: [
        new transports.Console({
          format: format.combine(
            format.colorize(),
            format.printf(({ context, message, level, time }) => {
              const strApp = chalk.green("[NEST]");
              // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
              const strContext = chalk.yellow(`[${context}]`);
              // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
              return `${strApp} - ${time} ${level} ${strContext} ${message}`;
            }),
          ),
        }),
        new transports.DailyRotateFile({
          format: format.combine(format.timestamp(), format.json()),
          dirname: "log",
          filename: "%DATE%.log",
          datePattern: "YYYY-MM-DD-HH-mm-ss",
        }),
      ],
    });
  }
  log(message: string, context: string[]) {
    const time = dayjs(Date.now()).format("YYYY-MM-DD HH:mm:ss");
    this.logger.log("info", message, { context, time });
  }
  error(message: string, context: string[]) {
    const time = dayjs(Date.now()).format("YYYY-MM-DD HH:mm:ss");
    this.logger.error(message, { context, time });
  }
  warn(message: string, context: string[]) {
    const time = dayjs(Date.now()).format("YYYY-MM-DD HH:mm:ss");
    this.logger.warn(message, { context, time });
  }
  debug?(message: string, context: string[]) {
    const time = dayjs(Date.now()).format("YYYY-MM-DD HH:mm:ss");
    this.logger.debug(message, { context, time });
  }
  verbose?(message: string, context: string[]) {
    const time = dayjs(Date.now()).format("YYYY-MM-DD HH:mm:ss");
    this.logger.verbose(message, { context, time });
  }
  fatal?(message: string, context: string[]) {
    const time = dayjs(Date.now()).format("YYYY-MM-DD HH:mm:ss");
    this.logger.error(message, { context, time });
  }
  setLogLevels?(levels: LogLevel[]) {
    // console.log('*=====LOG=====*[${context}] |', message)
    console.log(levels);
  }
}
