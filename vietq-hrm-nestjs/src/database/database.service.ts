import "dotenv/config";

import { Injectable, OnModuleDestroy, OnModuleInit } from "@nestjs/common";

import { PrismaClient } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";

const adapter = new PrismaPg({
  connectionString: process.env.DATABASE_URL,
});
@Injectable()
export class DatabaseService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor() {
    super({
      adapter: adapter,
      log: ["query", "info", "warn", "error"],
    });
  }

  async onModuleInit() {
    // Kiểm tra biến môi trường
    if (!process.env.DATABASE_URL) {
      throw new Error("DATABASE_URL is not defined in .env");
    }
    try {
      await this.$connect();
      console.log("Prisma connected");
    } catch (err) {
      console.error("Prisma connection error:", err);
      throw err;
    }
  }

  async onModuleDestroy() {
    await this.$disconnect();
    console.log("Prisma disconnected");
  }
}
