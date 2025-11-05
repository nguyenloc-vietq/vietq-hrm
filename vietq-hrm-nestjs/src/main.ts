import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { MyLogger } from './logger/my.logger';
import { MyLoggerDev } from './logger/my.logger.dev';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    // logger: new MyLogger
    // bufferLogs: true
  });
  
  app.useLogger(new MyLogger);
  console.log('*=============> App ruing in port: '+ process.env.PORT);
  await app.listen(process.env.PORT ?? 1509);
}
bootstrap();
