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

# Executar o comando correto do Postiz (usa pnpm e PM2)
cd /app
echo "🔨 Fazendo build se necessário..."
pnpm run build 2>/dev/null || echo "Build já feito ou não necessário"

echo "⚡ Iniciando com PM2..."
exec pnpm run pm2-run
