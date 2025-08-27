FROM ghcr.io/gitroomhq/postiz-app:latest

# Set working directory
WORKDIR /app

# Railway configuration
ENV NODE_ENV=production
ENV IS_GENERAL=true
ENV STORAGE_PROVIDER=local
ENV UPLOAD_DIRECTORY=/uploads
ENV NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads

# Create uploads directory
RUN mkdir -p /uploads

# Railway will set PORT dynamically
# The original image already exposes the correct port and has startup command
