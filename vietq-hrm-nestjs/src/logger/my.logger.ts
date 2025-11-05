import { createLogger, format, Logger, transport, transports } from 'winston';
import 'winston-daily-rotate-file'
import { LoggerService, LogLevel } from '@nestjs/common';
import chalk from 'chalk';
import dayjs from 'dayjs';

export class MyLogger implements LoggerService {
  private logger: Logger;
  constructor() {
    this.logger = createLogger({
      level: 'debug',
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
              const strApp = chalk.green('[NEST]');
              const strContext = chalk.yellow(`[${context}]`);
              return `${strApp} - ${time} ${level} ${strContext} ${message}`;
            }),
          ),
        }),
        new transports.DailyRotateFile({
            format: format.combine(
                format.timestamp(),
                format.json()
            ),
            dirname: 'log',
            filename: '%DATE%.log',
            datePattern: 'YYYY-MM-DD-HH:mm'
        })
      ],
    });
  }
  log(message: string, context: string[]) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    this.logger.log('info', message, {context, time});
  }
  error(message: string, context: string[]) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    this.logger.log('erorr', message, {context, time});
  }
  warn(message: string, context: string[]) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    this.logger.log('warn', message, {context, time});
  }
  debug?(message: string, context: string[]) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    this.logger.log('debug', message, {context, time});
  }
  verbose?(message: string, context: string[]) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    this.logger.log('verbose', message, {context, time});
  }
  fatal?(message: string, context: string[]) {
    const time = dayjs(Date.now()).format('YYYY-MM-DD HH:mm:ss')
    this.logger.log('final', message, {context, time});
  }
  setLogLevels?(levels: LogLevel[]) {
    // console.log('*=====LOG=====*[${context}] |', message)
  }
}
