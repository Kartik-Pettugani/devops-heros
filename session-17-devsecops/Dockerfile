{
  "name": "devsecops-app",
  "version": "1.0.0",
  "description": "DevSecOps Production Application with Automated Security Gates",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest --verbose"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "supertest": "^6.3.3"
  }
}
---
# Hardened Non-Root Container Image
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=build /app/node_modules ./node_modules
COPY src/ ./src/
USER appuser
EXPOSE 8080
CMD ["node", "src/index.js"]
