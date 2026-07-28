# ------------------------------
# Stage 1: Install dependencies
# ------------------------------
FROM node:26-alpine AS deps

WORKDIR /app

# Copy only package files first (leverages Docker layer caching - dependencies are re-installed only when package files change)
COPY package.json package-lock.json ./

# Install all dependencies (including dev dependencies)
RUN npm ci

# ----------------------------------
# Stage 2: Build TypeScript source
# ----------------------------------
FROM node:26-alpine AS build

WORKDIR /app

# Copy node_modules from deps stage (avoids re-downloading)
COPY --from=deps /app/node_modules ./node_modules

# Copy source code and tsconfig
COPY package.json tsconfig.json ./
COPY src ./src

# Compile TypeScript to JavaScript into /app/dist
RUN npx tsc

# ---------------------------------
# Stage 3: Production image
FROM node:26-alpine AS production
# ---------------------------------

WORKDIR /app

# Copy package files again for the production install
COPY package.json package-lock.json ./

# Install only production dependencies (no typescript, no @types/*) to keep the final image small
RUN npm ci --omit=dev

# Copy compiled JavaScript from the build stage
COPY --from=build /app/dist ./dist

# Run as non-root user for security
USER node

# Expose the port the app listens on
EXPOSE 3000

# Start the app
CMD ["node", "dist/index.js"]
