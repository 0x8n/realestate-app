# Build stage
FROM node:22-alpine AS builder
WORKDIR /app

COPY package.json yarn.lock ./
COPY .yarn .yarn
COPY .yarnrc.yml ./
COPY tsconfig.* vite.config.ts ./
COPY index.html ./
COPY public ./public
COPY src ./src

RUN corepack enable && corepack prepare yarn@stable --activate
RUN yarn install --immutable
# Make sure this runs "vite build" to create /dist
RUN yarn build  

# Serve with nginx
FROM nginx:alpine AS runner
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
