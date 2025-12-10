import { Module } from "@nestjs/common";
import { RegistrationService } from "./registration.service";
import { RegistrationController } from "./registration.controller";
import { CodeGeneratorModule } from "src/code-generator/code-generator.module";

@Module({
  imports: [CodeGeneratorModule],
  controllers: [RegistrationController],
  providers: [RegistrationService],
})
export class RegistrationModule {}
