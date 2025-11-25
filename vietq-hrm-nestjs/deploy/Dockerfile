# ========= STAGE 1: Builder =========
FROM node:20-alpine AS builder

# Cài build tools cần thiết cho native modules (bcrypt, prisma, sharp,...)
RUN apk add --no-cache python3 py3-pip build-base bash git

WORKDIR /app

# Copy chỉ file quản lý dependencies trước (tận dụng cache)
COPY package*.json ./
COPY prisma ./prisma/

# Cài dependencies (cả devDependencies để build)
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma Client + Build NestJS
RUN npm run build
RUN npx prisma generate

# ========= STAGE 2: Prune dependencies =========
FROM node:20-alpine AS deps

WORKDIR /app

# Chỉ cài production dependencies + tối ưu bằng npm ci --omit=dev
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# ========= STAGE 3: Final runtime image (siêu nhỏ) =========
FROM node:20-alpine AS runtime

WORKDIR /app

# Tạo user non-root (tăng security)
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs

# Copy node_modules production từ stage deps
COPY --from=deps /app/node_modules ./node_modules

# Copy build output + prisma từ builder
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/package.json ./package.json

# Generate lại Prisma client trong runtime image (đảm bảo đúng platform)
RUN npx prisma generate --no-engine

# Chuyển quyền sở hữu cho user non-root
RUN chown -R nestjs:nodejs /app
USER nestjs

# Expose port
EXPOSE 3592

# Healthcheck (tùy chọn nhưng rất nên có)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3592/health || exit 1

# Start app
CMD ["node", "dist/main.js"]