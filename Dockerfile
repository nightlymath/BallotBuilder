# Multi-stage Dockerfile for BallotBuilder (production/validation)

############################
# Builder (install deps & build)
############################
FROM node:18-slim AS builder
WORKDIR /app

# Install build-time dependencies
COPY package*.json ./
RUN npm ci --no-fund --no-audit

# Copy source and build
COPY . .
RUN npm run build

############################
# Runner (production-ready, smaller)
############################
FROM node:18-slim AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copy only what's needed from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["npm", "run", "start"]
