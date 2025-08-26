#!/bin/bash

echo "🚀 Preparando Postiz para Deploy em Produção"
echo "============================================="
echo

# Verificar se estamos no diretório correto
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Arquivo docker-compose.yml não encontrado!"
    echo "Execute este script na pasta do Postiz."
    exit 1
fi

echo "📋 Este script irá:"
echo "   ✅ Criar versão de produção do docker-compose.yml"
echo "   ✅ Configurar URLs para seu domínio"
echo "   ✅ Habilitar configurações de segurança"
echo "   ✅ Gerar JWT secret seguro"
echo "   ✅ Preparar para TikTok em produção"
echo

# Solicitar informações
read -p "🌐 Digite seu domínio (ex: postiz.meusite.com): " DOMAIN
if [ -z "$DOMAIN" ]; then
    echo "❌ Domínio é obrigatório!"
    exit 1
fi

echo
read -p "🔐 Deseja configurar credenciais TikTok agora? (y/n): " -n 1 -r SETUP_TIKTOK
echo

# Variáveis TikTok
TIKTOK_CLIENT_ID=""
TIKTOK_CLIENT_SECRET=""

if [[ $SETUP_TIKTOK =~ ^[Yy]$ ]]; then
    echo
    echo "🎵 Configuração TikTok:"
    echo "   📋 Redirect URI: https://$DOMAIN/integrations/social/tiktok"
    echo
    read -p "   Client ID (16 caracteres): " TIKTOK_CLIENT_ID
    read -p "   Client Secret (32 caracteres): " TIKTOK_CLIENT_SECRET
fi

echo
echo "🔧 Gerando configurações..."

# Gerar JWT secret seguro
JWT_SECRET=$(openssl rand -base64 64 | tr -d '\n')
echo "🔑 JWT Secret gerado"

# Gerar senha forte para banco
DB_PASSWORD=$(openssl rand -hex 16)
echo "🗄️  Senha do banco gerada"

# Criar backup
cp docker-compose.yml docker-compose.yml.backup
echo "📋 Backup criado: docker-compose.yml.backup"

# Criar versão de produção
cat > docker-compose.prod.yml << EOF
services:
  postiz:
    image: ghcr.io/gitroomhq/postiz-app:latest
    container_name: postiz
    restart: always
    environment:
      # URLs de produção
      MAIN_URL: "https://$DOMAIN"
      FRONTEND_URL: "https://$DOMAIN"
      NEXT_PUBLIC_BACKEND_URL: "https://$DOMAIN/api"
      JWT_SECRET: "$JWT_SECRET"
      
      # Database e Redis
      DATABASE_URL: "postgresql://postiz-user:$DB_PASSWORD@postiz-postgres:5432/postiz-db-local"
      REDIS_URL: "redis://postiz-redis:6379"
      BACKEND_INTERNAL_URL: "http://localhost:3000"
      IS_GENERAL: "true"
      DISABLE_REGISTRATION: "true"
      
      # Storage
      STORAGE_PROVIDER: "local"
      UPLOAD_DIRECTORY: "/uploads"
      NEXT_PUBLIC_UPLOAD_DIRECTORY: "/uploads"
      
      # Segurança habilitada (NOT_SECURED removido para produção)
EOF

# Adicionar TikTok se configurado
if [ ! -z "$TIKTOK_CLIENT_ID" ] && [ ! -z "$TIKTOK_CLIENT_SECRET" ]; then
    cat >> docker-compose.prod.yml << EOF
      
      # TikTok API
      TIKTOK_CLIENT_ID: "$TIKTOK_CLIENT_ID"
      TIKTOK_CLIENT_SECRET: "$TIKTOK_CLIENT_SECRET"
EOF
    echo "🎵 Credenciais TikTok adicionadas"
fi

# Continuar o arquivo
cat >> docker-compose.prod.yml << EOF
    volumes:
      - postiz-config:/config/
      - postiz-uploads:/uploads/
    ports:
      - 5001:5000
    networks:
      - postiz-network
    depends_on:
      postiz-postgres:
        condition: service_healthy
      postiz-redis:
        condition: service_healthy

  postiz-postgres:
    image: postgres:17-alpine
    container_name: postiz-postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: $DB_PASSWORD
      POSTGRES_USER: postiz-user
      POSTGRES_DB: postiz-db-local
    volumes:
      - postgres-volume:/var/lib/postgresql/data
    networks:
      - postiz-network
    healthcheck:
      test: pg_isready -U postiz-user -d postiz-db-local
      interval: 10s
      timeout: 3s
      retries: 3

  postiz-redis:
    image: redis:7.2
    container_name: postiz-redis
    restart: always
    healthcheck:
      test: redis-cli ping
      interval: 10s
      timeout: 3s
      retries: 3
    volumes:
      - postiz-redis-data:/data
    networks:
      - postiz-network

volumes:
  postgres-volume:
    external: false
  postiz-redis-data:
    external: false
  postiz-config:
    external: false
  postiz-uploads:
    external: false

networks:
  postiz-network:
    external: false
EOF

echo "✅ Arquivo de produção criado: docker-compose.prod.yml"

# Criar arquivo .env com configurações sensíveis
cat > .env.production << EOF
# Configurações para Produção - MANTER SEGURO!
# Gerado em: $(date)

DOMAIN=$DOMAIN
JWT_SECRET=$JWT_SECRET
DB_PASSWORD=$DB_PASSWORD

# TikTok (se configurado)
TIKTOK_CLIENT_ID=$TIKTOK_CLIENT_ID
TIKTOK_CLIENT_SECRET=$TIKTOK_CLIENT_SECRET

# URLs
MAIN_URL=https://$DOMAIN
FRONTEND_URL=https://$DOMAIN
NEXT_PUBLIC_BACKEND_URL=https://$DOMAIN/api
EOF

echo "🔐 Variáveis de ambiente salvas: .env.production"

# Criar script de deploy
cat > deploy.sh << 'EOF'
#!/bin/bash
echo "🚀 Fazendo deploy do Postiz..."

# Parar serviços se estiverem rodando
docker compose -f docker-compose.prod.yml down 2>/dev/null || true

# Fazer pull das imagens mais recentes
docker compose -f docker-compose.prod.yml pull

# Iniciar serviços
docker compose -f docker-compose.prod.yml up -d

echo "✅ Deploy concluído!"
echo "📋 Para verificar status: docker compose -f docker-compose.prod.yml ps"
echo "📋 Para ver logs: docker compose -f docker-compose.prod.yml logs -f postiz"
EOF

chmod +x deploy.sh
echo "📜 Script de deploy criado: deploy.sh"

# Criar README para produção
cat > DEPLOY_INSTRUCTIONS.md << EOF
# 📋 Instruções de Deploy

## Arquivos Criados

- \`docker-compose.prod.yml\` - Configuração de produção
- \`.env.production\` - Variáveis sensíveis (NÃO COMMITAR)
- \`deploy.sh\` - Script de deploy
- \`DEPLOY_INSTRUCTIONS.md\` - Este arquivo

## Configurações

- **Domínio:** https://$DOMAIN
- **TikTok Redirect URI:** https://$DOMAIN/integrations/social/tiktok
- **Segurança:** Habilitada (HTTPS obrigatório)
- **Registro:** Desabilitado após primeiro usuário

## Deploy em VPS/Servidor

1. Fazer upload dos arquivos:
   \`\`\`bash
   scp docker-compose.prod.yml deploy.sh root@SEU_IP:/root/postiz/
   \`\`\`

2. No servidor:
   \`\`\`bash
   cd /root/postiz
   ./deploy.sh
   \`\`\`

## Deploy em Railway/Render

1. Fazer push para GitHub:
   \`\`\`bash
   git add .
   git commit -m "feat: configuração para produção"
   git push
   \`\`\`

2. Conectar repositório na plataforma
3. Usar \`docker-compose.prod.yml\` como configuração

## Configuração DNS

Configure seu domínio para apontar para o servidor:
- **Tipo:** A
- **Nome:** @ ou postiz
- **Valor:** IP_DO_SERVIDOR

## Primeiro Acesso

1. Acesse: https://$DOMAIN
2. Crie sua conta (primeira pessoa)
3. O registro será automaticamente desabilitado

## TikTok

EOF

if [ ! -z "$TIKTOK_CLIENT_ID" ]; then
    cat >> DEPLOY_INSTRUCTIONS.md << EOF
- **Configurado:** ✅ Sim
- **Redirect URI:** https://$DOMAIN/integrations/social/tiktok
- **Client ID:** $TIKTOK_CLIENT_ID (primeiros 8 chars)
EOF
else
    cat >> DEPLOY_INSTRUCTIONS.md << EOF
- **Configurado:** ❌ Não configurado
- Para configurar depois, edite \`docker-compose.prod.yml\` e adicione:
  \`\`\`yaml
  TIKTOK_CLIENT_ID: "seu_client_id"
  TIKTOK_CLIENT_SECRET: "seu_client_secret"
  \`\`\`
EOF
fi

cat >> DEPLOY_INSTRUCTIONS.md << EOF

## Comandos Úteis

\`\`\`bash
# Ver status
docker compose -f docker-compose.prod.yml ps

# Ver logs
docker compose -f docker-compose.prod.yml logs -f postiz

# Reiniciar
docker compose -f docker-compose.prod.yml restart

# Backup
docker compose -f docker-compose.prod.yml exec postiz-postgres pg_dump -U postiz-user postiz-db-local > backup.sql
\`\`\`
EOF

echo "📖 Instruções criadas: DEPLOY_INSTRUCTIONS.md"

# Atualizar .gitignore
cat >> .gitignore << EOF

# Produção - não commitar
.env.production
docker-compose.prod.yml.backup
*.backup
backup.sql
EOF

echo
echo "🎉 Preparação para produção concluída!"
echo
echo "📁 Arquivos criados:"
echo "   📄 docker-compose.prod.yml - Configuração de produção"
echo "   🔐 .env.production - Variáveis sensíveis"
echo "   🚀 deploy.sh - Script de deploy"
echo "   📖 DEPLOY_INSTRUCTIONS.md - Instruções completas"
echo
echo "🌐 Domínio configurado: https://$DOMAIN"
if [ ! -z "$TIKTOK_CLIENT_ID" ]; then
echo "🎵 TikTok Redirect URI: https://$DOMAIN/integrations/social/tiktok"
fi
echo
echo "📋 Próximos passos:"
echo "   1. Configure DNS do seu domínio"
echo "   2. Escolha plataforma de deploy (VPS, Railway, etc.)"
echo "   3. Faça upload dos arquivos"
echo "   4. Execute ./deploy.sh"
echo "   5. Configure certificado SSL"
echo
echo "📖 Leia DEPLOY_INSTRUCTIONS.md para instruções detalhadas"
