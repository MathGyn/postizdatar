FROM ghcr.io/gitroomhq/postiz-app:latest

# Railway sets these automatically:
# - DATABASE_URL (PostgreSQL)
# - REDIS_URL (Redis) 
# - RAILWAY_STATIC_URL (domain)
# - PORT (dynamic port)

# Required environment variables
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
