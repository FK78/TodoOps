FROM node:26-alpine AS deps

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

FROM node:26-alpine AS build

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY package.json tsconfig.json ./
COPY src ./src

RUN npx tsc

FROM node:26-alpine AS production

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist

USER node

EXPOSE 3000

CMD ["node", "dist/index.js"]
