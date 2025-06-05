FROM node:22-slim AS builder

WORKDIR /app
COPY . .

RUN yarn install
RUN yarn add -D @types/node
RUN yarn build

FROM node:22-slim AS runner

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json .
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", "dist/server/server.js"]
