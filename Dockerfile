FROM ghcr.io/gitroomhq/postiz-app:latest

# Usar variáveis de ambiente do Railway
ENV RAILWAY_STATIC_URL=${RAILWAY_STATIC_URL}
ENV DATABASE_URL=${DATABASE_URL}
ENV REDIS_URL=${REDIS_URL}

EXPOSE 5000

CMD ["node", "dist/backend/main.js"]
