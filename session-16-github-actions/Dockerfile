# Multi-stage Dockerfile for production efficiency
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:18-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --only=production
COPY src/ ./src/

EXPOSE 3000
USER node
CMD ["node", "src/app.js"]
