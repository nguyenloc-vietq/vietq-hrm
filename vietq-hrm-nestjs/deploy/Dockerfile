# ========= STAGE 1: Builder =========
FROM node:20-alpine AS builder

# Build tools cần thiết cho native modules
RUN apk add --no-cache python3 make g++ bash git

WORKDIR /app

# Copy file quản lý dependencies trước để tận dụng cache
COPY package*.json ./
COPY prisma ./prisma/

# Cài tất cả dependencies để build
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma Client (cho platform alpine)
RUN npx prisma generate --binary-target="linux-musl"

# Build NestJS
RUN npm run build

# ========= STAGE 2: Production image =========
FROM node:20-alpine AS runtime

WORKDIR /app

# Tạo user non-root
RUN addgroup --system --gid 1001 nodejs \
 && adduser --system --uid 1001 nestjs

# Copy chỉ production dependencies
COPY package*.json ./
RUN npm ci --omit=dev --production && npm cache clean --force

# Copy build output và prisma client
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma

# Chuyển quyền sở hữu
RUN chown -R nestjs:nodejs /app
USER nestjs

# Expose port
EXPOSE 3592

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3592/health || exit 1

# Start app
CMD ["node", "dist/main.js"]
