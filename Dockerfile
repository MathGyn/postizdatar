FROM ghcr.io/gitroomhq/postiz-app:latest

# Set working directory
WORKDIR /app

# Railway uses dynamic PORT environment variable
ENV NODE_ENV=production

# Copy startup script
COPY start-railway.sh /start-railway.sh
RUN chmod +x /start-railway.sh

# Use our custom startup script
CMD ["/start-railway.sh"]
