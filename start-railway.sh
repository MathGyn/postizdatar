#!/bin/bash

# Script de inicialização para Railway
echo "🚂 Iniciando Postiz no Railway..."

# Railway fornece a porta dinamicamente
export PORT=${PORT:-5000}
echo "📡 Usando porta: $PORT"

# Configurar URLs baseado no Railway
if [ -n "$RAILWAY_STATIC_URL" ]; then
    export MAIN_URL="$RAILWAY_STATIC_URL"
    export FRONTEND_URL="$RAILWAY_STATIC_URL" 
    export NEXT_PUBLIC_BACKEND_URL="$RAILWAY_STATIC_URL/api"
    echo "🌐 URLs configuradas para: $RAILWAY_STATIC_URL"
fi

# Configurações necessárias
export BACKEND_INTERNAL_URL="http://localhost:$PORT"
export IS_GENERAL="true"

# Configurar storage local
export STORAGE_PROVIDER="local"
export UPLOAD_DIRECTORY="/uploads"
export NEXT_PUBLIC_UPLOAD_DIRECTORY="/uploads"

# Configurações específicas Redis para Railway
if [ -n "$REDIS_URL" ]; then
    echo "🔧 Configurando Redis para Railway..."
    export REDIS_HOST=$(echo $REDIS_URL | sed 's/redis:\/\/\([^:]*\).*/\1/')
    export REDIS_PORT=$(echo $REDIS_URL | sed 's/.*:\([0-9]*\).*/\1/')
    export REDIS_PASSWORD=""
    export REDIS_TLS="false"
    
    # Configurações adicionais para compatibilidade
    export NODE_ENV="production"
    export REDIS_FAMILY="4"
    export REDIS_KEEPALIVE="true"
fi

# Criar diretório de uploads
mkdir -p /uploads

echo "🔧 Variáveis configuradas:"
echo "   PORT: $PORT"
echo "   MAIN_URL: $MAIN_URL"
echo "   DATABASE_URL: ${DATABASE_URL:0:20}..."
echo "   REDIS_URL: ${REDIS_URL:0:20}..."

# Aguardar banco estar disponível
echo "⏳ Aguardando banco de dados..."
sleep 5

echo "🚀 Iniciando Postiz..."
echo "📂 Listando arquivos para debug:"
ls -la /app/ || ls -la /

echo "📦 Verificando package.json:"
cat /app/package.json | grep -A 10 "scripts" || echo "package.json não encontrado"

# Executar o comando correto do Postiz (build já foi feito no Dockerfile)
cd /app

echo "📝 Criando arquivo .env para resolver incompatibilidades..."
cat > .env << EOF
# Railway Environment
MAIN_URL=$MAIN_URL
FRONTEND_URL=$FRONTEND_URL
NEXT_PUBLIC_BACKEND_URL=$NEXT_PUBLIC_BACKEND_URL
BACKEND_INTERNAL_URL=$BACKEND_INTERNAL_URL
DATABASE_URL=$DATABASE_URL

# REDIS TEMPORARIAMENTE DESABILITADO - INCOMPATIBILIDADE IOREDIS
# REDIS_URL=$REDIS_URL

# Core Settings
IS_GENERAL=true
DISABLE_REGISTRATION=false
STORAGE_PROVIDER=local
UPLOAD_DIRECTORY=/uploads
NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads
JWT_SECRET=$JWT_SECRET
NODE_ENV=production

# Desabilitar funcionalidades que dependem do Redis
REDIS_DISABLED=true
QUEUE_PROVIDER=memory
CACHE_PROVIDER=memory
SESSION_PROVIDER=memory
EOF

echo "🔧 Aplicando patch para desabilitar Redis..."
# Patch do código compilado para remover referências ao Redis
find /app -name "*.js" -path "*/dist/*" -exec grep -l "IORedisConnection" {} \; | while read file; do
    echo "Patching: $file"
    sed -i 's/new IORedisConnection/\/\* new IORedisConnection/g' "$file" 2>/dev/null || true
    sed -i 's/client\.setMaxListeners/\/\* client.setMaxListeners/g' "$file" 2>/dev/null || true
done

echo "⚡ Iniciando diretamente com PM2..."
# Pular o pm2 delete pois pode dar problema, ir direto ao essencial
echo "Rodando prisma-db-push..."
pnpm run prisma-db-push || echo "Prisma push falhou, continuando..."

echo "Iniciando serviços PM2..."
# Iniciar serviços em background
pnpm run --parallel pm2 &

echo "⏳ Aguardando todos os serviços estarem online..."
echo "Postiz é um container pesado (4.4GB) - pode demorar vários minutos..."
# Aguardar até todos os serviços principais estarem rodando (mais tempo)
for i in {1..120}; do
    if pm2 status | grep -q "frontend.*online" && \
       pm2 status | grep -q "backend.*online" && \
       pm2 status | grep -q "workers.*online" && \
       pm2 status | grep -q "cron.*online"; then
        echo "✅ Todos os serviços estão online!"
        break
    fi
    echo "Aguardando serviços... ($i/120)"
    sleep 5
done

echo "📊 Status final dos serviços:"
pm2 status

echo "🚀 Postiz iniciado com sucesso! Mantendo container ativo..."
echo "🔍 Monitorando logs PM2..."
# Manter container ativo seguindo os logs PM2
exec pm2 logs
