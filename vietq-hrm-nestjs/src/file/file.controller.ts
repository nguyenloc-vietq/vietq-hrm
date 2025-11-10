/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Req,
  Res,
} from "@nestjs/common";
import { FileService } from "./file.service";
import { PermitAll } from "src/common/custom-decorator";

@Controller("file")
export class FileController {
  constructor(private readonly fileService: FileService) {}

  @Get("/*filename")
  @PermitAll()
  async getFile(@Param("filename") filename: string, @Res() res: any) {
    return this.fileService.getFile(filename, res);
  }
}
