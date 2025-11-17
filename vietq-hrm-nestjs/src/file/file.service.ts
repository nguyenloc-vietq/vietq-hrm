import { Injectable, NotFoundException } from "@nestjs/common";
import { join } from "path";
import * as fs from "fs";
import { Response } from "express";
@Injectable()
export class FileService {
  async getFile(filename: string, res: Response) {
    const safePath = Array.isArray(filename) ? filename.join("/") : filename;
    const file = join(process.cwd(), "src", "uploads", safePath);
    console.log(`[===============> file |`, file);
    if (!fs.existsSync(file)) {
      throw new NotFoundException("File not found");
    }

    return res.sendFile(file);
  }
}
