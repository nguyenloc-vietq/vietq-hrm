"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
const my_logger_1 = require("./logger/my.logger");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule, {});
    app.useLogger(new my_logger_1.MyLogger);
    console.log('*=============> App ruing in port: ' + process.env.PORT);
    await app.listen(process.env.PORT ?? 1509);
}
bootstrap();
//# sourceMappingURL=main.js.map