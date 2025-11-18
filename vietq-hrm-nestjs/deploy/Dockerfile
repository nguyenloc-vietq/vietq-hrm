# Chọn Node LTS, Alpine nhẹ
FROM node:20-alpine

# Cài thêm build tools nếu dùng bcrypt / prisma
RUN apk add --no-cache python3 make g++ bash git

WORKDIR /app

# Copy package.json + package-lock.json
COPY package*.json ./

# Cài dev + production dependencies để build
RUN npm install

# Copy toàn bộ source code
COPY . .

# Build NestJS & generate Prisma client
RUN npm run build
RUN npx prisma generate

# Expose port
EXPOSE 1900

# Chạy NestJS
CMD ["node", "dist/src/main.js"]
