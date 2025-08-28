FROM ghcr.io/gitroomhq/postiz-app:latest

# Copy railway script
COPY start-railway.sh /usr/local/bin/start-railway.sh
RUN chmod +x /usr/local/bin/start-railway.sh

# Pre-build during Docker build (not runtime)
WORKDIR /app
RUN pnpm run build || echo "Build failed but continuing..."

# Required environment variables (basic)
ENV NODE_ENV=production
ENV IS_GENERAL=true
ENV DISABLE_REGISTRATION=false
ENV STORAGE_PROVIDER=local
ENV UPLOAD_DIRECTORY=/uploads
ENV NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads

# Create uploads directory
RUN mkdir -p /uploads

# Expose port (Railway will map dynamically)
EXPOSE 5000

# Use railway script as entrypoint (will call original CMD)
ENTRYPOINT ["/usr/local/bin/start-railway.sh"]
