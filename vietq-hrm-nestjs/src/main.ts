import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { NestExpressApplication } from "@nestjs/platform-express";
import { MyLogger } from "./logger/my.logger";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AllExceptionsFilter } from "./exception/http-exception.filter";
import { join } from "path";
import * as express from "express";
// import { MyLoggerDev } from './logger/my.logger.dev';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    // logger: new MyLogger
    // bufferLogs: true
  });
  app.enableCors({
    origin: "*", // cho phép tất cả domain
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
    allowedHeaders: "*", // cho phép mọi header
    credentials: true, // nếu bạn cần cookie hoặc Authorization header
  });
  app.setGlobalPrefix("api");
  const config = new DocumentBuilder()
    .setTitle("Vietq HRM")
    .setDescription("The Vietq HRM API description")
    .setVersion("1.0")
    .addBearerAuth(
      {
        type: "http",
        scheme: "bearer",
        bearerFormat: "JWT",
        description: "Enter JWT token",
      },
      "access-token",
    )
    .addTag("vietq-hrm")
    .build();
  const docummentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api/docs", app, docummentFactory, {
    swaggerOptions: {
      persistAuthorization: true,
    },
  });
  SwaggerModule.setup("swagger", app, docummentFactory, {
    jsonDocumentUrl: "swagger/docs",
  });
  app.useGlobalFilters(new AllExceptionsFilter());
  app.useLogger(new MyLogger());
  console.log(`[===============> App Runnig in Port | ${process.env.PORT}`);
  app.use("/uploads", express.static(join(__dirname, "..", "src/uploads")));
  await app.listen(process.env.PORT ?? 1509);
}
bootstrap();
