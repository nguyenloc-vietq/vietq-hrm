"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MyLoggerDev = void 0;
const common_1 = require("@nestjs/common");
class MyLoggerDev extends common_1.ConsoleLogger {
    log(message, context) {
        console.log(`[${context}] | `, message);
    }
}
exports.MyLoggerDev = MyLoggerDev;
//# sourceMappingURL=my.logger.dev.js.map