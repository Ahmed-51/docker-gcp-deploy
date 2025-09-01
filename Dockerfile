# Stage 1 - Build React App
FROM node:22.14-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2 - Serve via Nginx with Brotli + Caching
FROM nginx:stable-alpine

# Install Brotli module for better compression
RUN apk add --no-cache brotli

# Remove default Nginx configs
RUN rm -rf /etc/nginx/conf.d/*

# Copy optimized configs
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy React build
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
