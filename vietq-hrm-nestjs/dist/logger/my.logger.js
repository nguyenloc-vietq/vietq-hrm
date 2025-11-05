"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.MyLogger = void 0;
const winston_1 = require("winston");
require("winston-daily-rotate-file");
const chalk_1 = __importDefault(require("chalk"));
const dayjs_1 = __importDefault(require("dayjs"));
class MyLogger {
    logger;
    constructor() {
        this.logger = (0, winston_1.createLogger)({
            level: 'debug',
            transports: [
                new winston_1.transports.Console({
                    format: winston_1.format.combine(winston_1.format.colorize(), winston_1.format.printf(({ context, message, level, time }) => {
                        const strApp = chalk_1.default.green('[NEST]');
                        const strContext = chalk_1.default.yellow(`[${context}]`);
                        return `${strApp} - ${time} ${level} ${strContext} ${message}`;
                    })),
                }),
                new winston_1.transports.DailyRotateFile({
                    format: winston_1.format.combine(winston_1.format.timestamp(), winston_1.format.json()),
                    dirname: 'log',
                    filename: '%DATE%.log',
                    datePattern: 'YYYY-MM-DD-HH:mm'
                })
            ],
        });
    }
    log(message, context) {
        const time = (0, dayjs_1.default)(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        this.logger.log('info', message, { context, time });
    }
    error(message, context) {
        const time = (0, dayjs_1.default)(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        this.logger.log('erorr', message, { context, time });
    }
    warn(message, context) {
        const time = (0, dayjs_1.default)(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        this.logger.log('warn', message, { context, time });
    }
    debug(message, context) {
        const time = (0, dayjs_1.default)(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        this.logger.log('debug', message, { context, time });
    }
    verbose(message, context) {
        const time = (0, dayjs_1.default)(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        this.logger.log('verbose', message, { context, time });
    }
    fatal(message, context) {
        const time = (0, dayjs_1.default)(Date.now()).format('YYYY-MM-DD HH:mm:ss');
        this.logger.log('final', message, { context, time });
    }
    setLogLevels(levels) {
    }
}
exports.MyLogger = MyLogger;
//# sourceMappingURL=my.logger.js.map