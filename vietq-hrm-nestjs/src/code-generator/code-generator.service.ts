/* eslint-disable @typescript-eslint/no-explicit-any */
import { Injectable } from "@nestjs/common";
import { DatabaseService } from "src/database/database.service";

@Injectable()
export class CodeGeneratorService {
  constructor(private prisma: DatabaseService) {}

  async generateCode(
    modelDelegate: any,
    prefix: string,
    options?: {
      field?: string;
      digits?: number;
      extraWhere?: Record<string, any>;
    },
  ): Promise<string> {
    const field = options?.field ?? "code";
    const digits = options?.digits ?? 6;
    const extraWhere = options?.extraWhere ?? {};

    // Tìm bản ghi có code lớn nhất trong nhóm prefix
    const latest = await modelDelegate.findFirst({
      where: {
        AND: [{ [field]: { startsWith: prefix } }, extraWhere],
      },
      orderBy: { [field]: "desc" },
      select: { [field]: true },
    });

    let nextNumber = 1;

    if (latest && latest[field]) {
      const raw = latest[field] as string;
      const numPart = raw.slice(prefix.length);
      const parsed = parseInt(numPart, 10);
      if (!isNaN(parsed)) nextNumber = parsed + 1;
    }

    const numStr = String(nextNumber).padStart(digits, "0");
    return `${prefix}${numStr}`;
  }
}
