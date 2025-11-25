import "dotenv/config";

import { defineConfig } from "prisma/config";

// prisma.config.ts

export default defineConfig({
  // Config cho datasource (thay thế url cũ)
  datasource: {
    url: process.env.DATABASE_URL ?? "", // Dùng .env như trước
  },
  // Các options khác nếu cần (log, preview features, v.v.)
  //   log: ["query", "info", "warn", "error"],
});
