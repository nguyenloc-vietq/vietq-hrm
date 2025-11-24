import { Module } from "@nestjs/common";
import { UserService } from "./user.service";
import { UserController } from "./user.controller";
import { CodeGeneratorModule } from "src/code-generator/code-generator.module";

@Module({
  imports: [CodeGeneratorModule],
  controllers: [UserController],
  providers: [UserService],
})
export class UserModule {}
