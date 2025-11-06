import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { NestExpressApplication } from "@nestjs/platform-express";
import { MyLogger } from "./logger/my.logger";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AllExceptionsFilter } from "./exception/http-exception.filter";
// import { MyLoggerDev } from './logger/my.logger.dev';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    // logger: new MyLogger
    // bufferLogs: true
  });
  app.setGlobalPrefix("api");
  const config = new DocumentBuilder()
    .setTitle("Vietq HRM")
    .setDescription("The Vietq HRM API description")
    .setVersion("1.0")
    .addTag("vietq-hrm")
    .build();
  const docummentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api/docs", app, docummentFactory);
  SwaggerModule.setup("swagger", app, docummentFactory, {
    jsonDocumentUrl: "swagger/docs",
  });
  app.useGlobalFilters(new AllExceptionsFilter());
  app.useLogger(new MyLogger());
  console.log(`[===============> App Runnig in Port | ${process.env.PORT}`);
  await app.listen(process.env.PORT ?? 1509);
}
bootstrap();
