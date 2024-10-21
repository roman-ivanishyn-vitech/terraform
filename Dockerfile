FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./
RUN npm install
COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build
FROM nginx:alpine
COPY --from=builder /app/dist/invites /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
