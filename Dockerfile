FROM ghcr.io/gitroomhq/postiz-app:latest

# Set working directory
WORKDIR /app

# Expose port 5000 (Postiz default)
EXPOSE 5000

# Railway will provide these environment variables
ENV PORT=5000
ENV NODE_ENV=production

# Use the default entrypoint from the Postiz image
# The Postiz image already has the correct startup command
