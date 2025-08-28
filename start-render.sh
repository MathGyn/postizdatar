#!/bin/bash

# Script de inicialização para Render
echo "🎨 Iniciando Postiz no Render..."

# Render fornece as variáveis automaticamente via Blueprint
echo "📡 Usando porta: ${PORT:-5000}"

# Configurar URLs baseado no Render (será preenchido após deploy)
if [ -z "$MAIN_URL" ]; then
    echo "⚠️ MAIN_URL não configurada - será necessário configurar manualmente após deploy"
fi

echo "🔧 Variáveis configuradas:"
echo "   PORT: ${PORT:-5000}"
echo "   MAIN_URL: ${MAIN_URL:-'[A CONFIGURAR]'}"
echo "   DATABASE_URL: ${DATABASE_URL:0:20}..."
echo "   REDIS_URL: ${REDIS_URL:0:20}..."

# Criar diretório de uploads
mkdir -p /uploads

# Aguardar serviços estarem disponíveis
echo "⏳ Aguardando banco e Redis estarem disponíveis..."
echo "Database URL: ${DATABASE_URL:0:30}..."
echo "Redis URL: ${REDIS_URL:0:30}..."
sleep 15

echo "🚀 Iniciando Postiz..."
cd /app

echo "📝 Configurando ambiente Render..."
# Verificar se as variáveis estão disponíveis
if [ -z "$DATABASE_URL" ]; then
    echo "❌ Erro: DATABASE_URL não configurada!"
    exit 1
fi

echo "⚡ Iniciando com PM2..."
# Rodar prisma setup com mais logging
echo "🗬️ Configurando banco de dados (pode demorar)..."
pnpm run prisma-db-push || echo "⚠️ Prisma push falhou, continuando..."

echo "🔥 Iniciando serviços PM2..."
echo "Iniciando: pnpm run pm2-run"
# Usar comando direto (mais simples no Render)
exec pnpm run pm2-run
