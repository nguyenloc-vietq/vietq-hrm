import "dotenv/config";

import { Injectable, OnModuleDestroy, OnModuleInit } from "@nestjs/common";

import { PrismaClient } from "@prisma/client";
import { PrismaMariaDb } from "@prisma/adapter-mariadb";

const adapter = new PrismaMariaDb({
  host: process.env.DATABASE_HOST,
  user: process.env.DATABASE_USER,
  port: Number(process.env.DATABASE_PORT),
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  // connectionLimit: 5,
  // Other connection options can be added here
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
