#!/bin/bash

echo "🚂 Setup Postiz para Railway (GRATUITO)"
echo "======================================"
echo

echo "💰 Railway Free Tier inclui:"
echo "   ✅ $5 crédito/mês (suficiente para começar)"
echo "   ✅ PostgreSQL automático"
echo "   ✅ Redis automático" 
echo "   ✅ HTTPS + domínio grátis"
echo "   ✅ Deploy automático via GitHub"
echo

# Verificar se git está configurado
if ! git config user.name &> /dev/null; then
    echo "⚠️  Configure o Git primeiro:"
    echo "   git config --global user.name 'Seu Nome'"
    echo "   git config --global user.email 'seu@email.com'"
    exit 1
fi

# Verificar se existe repositório remoto
if ! git remote get-url origin &> /dev/null; then
    echo "📋 Você precisa de um repositório GitHub primeiro."
    echo "1. Crie um repositório em: https://github.com/new"
    echo "2. Execute:"
    echo "   git remote add origin https://github.com/seuusuario/seu-repo.git"
    echo "   git push -u origin main"
    echo
    read -p "Já criou o repositório GitHub? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "👋 Volte quando tiver o repositório pronto!"
        exit 0
    fi
fi

echo "🔧 Configurando para Railway..."

# Perguntar sobre TikTok
read -p "🎵 Configurar TikTok agora? (y/n): " -n 1 -r SETUP_TIKTOK
echo

TIKTOK_CLIENT_ID=""
TIKTOK_CLIENT_SECRET=""

if [[ $SETUP_TIKTOK =~ ^[Yy]$ ]]; then
    echo
    echo "📋 Para TikTok, você precisará configurar:"
    echo "   1. App em: https://developers.tiktok.com/apps"
    echo "   2. Redirect URI: https://SEU_DOMINIO_RAILWAY/integrations/social/tiktok"
    echo "   3. Railway gerará o domínio automaticamente após deploy"
    echo
    read -p "   Client ID: " TIKTOK_CLIENT_ID
    read -p "   Client Secret: " TIKTOK_CLIENT_SECRET
    echo "💡 Você pode adicionar estes dados no Railway Dashboard depois também!"
fi

# Gerar configurações
JWT_SECRET=$(openssl rand -base64 64 | tr -d '\n')
DB_PASSWORD=$(openssl rand -hex 16)

echo
echo "🔧 Criando configuração para Railway..."

# Criar docker-compose específico para Railway
cat > docker-compose.railway.yml << EOF
services:
  postiz:
    image: ghcr.io/gitroomhq/postiz-app:latest
    restart: always
    environment:
      # URLs - Railway gera automaticamente
      MAIN_URL: \${RAILWAY_STATIC_URL}
      FRONTEND_URL: \${RAILWAY_STATIC_URL}
      NEXT_PUBLIC_BACKEND_URL: \${RAILWAY_STATIC_URL}/api
      JWT_SECRET: "$JWT_SECRET"
      
      # Railway fornece estas automaticamente
      DATABASE_URL: \${DATABASE_URL}
      REDIS_URL: \${REDIS_URL}
      
      BACKEND_INTERNAL_URL: "http://localhost:3000"
      IS_GENERAL: "true"
      DISABLE_REGISTRATION: "true"
      
      # Storage
      STORAGE_PROVIDER: "local"
      UPLOAD_DIRECTORY: "/uploads"
      NEXT_PUBLIC_UPLOAD_DIRECTORY: "/uploads"
      
      # Segurança habilitada para produção
EOF

# Adicionar TikTok se configurado
if [ ! -z "$TIKTOK_CLIENT_ID" ] && [ ! -z "$TIKTOK_CLIENT_SECRET" ]; then
    cat >> docker-compose.railway.yml << EOF
      
      # TikTok API
      TIKTOK_CLIENT_ID: "$TIKTOK_CLIENT_ID"
      TIKTOK_CLIENT_SECRET: "$TIKTOK_CLIENT_SECRET"
EOF
fi

cat >> docker-compose.railway.yml << EOF
    volumes:
      - uploads:/uploads
    ports:
      - 5000:5000

volumes:
  uploads:
EOF

# Criar railway.toml para configuração específica
cat > railway.toml << EOF
[build]
builder = "dockerfile"

[deploy]
healthcheckPath = "/"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 10

[variables]
JWT_SECRET = "$JWT_SECRET"
STORAGE_PROVIDER = "local"
IS_GENERAL = "true"
DISABLE_REGISTRATION = "true"
EOF

# Criar Dockerfile otimizado se não existir
if [ ! -f "Dockerfile" ]; then
    cat > Dockerfile << 'EOF'
FROM ghcr.io/gitroomhq/postiz-app:latest

# Usar variáveis de ambiente do Railway
ENV RAILWAY_STATIC_URL=${RAILWAY_STATIC_URL}
ENV DATABASE_URL=${DATABASE_URL}
ENV REDIS_URL=${REDIS_URL}

EXPOSE 5000

CMD ["node", "dist/backend/main.js"]
EOF
fi

# Criar arquivo com instruções
cat > RAILWAY_SETUP.md << EOF
# 🚂 Deploy no Railway - Instruções

## Arquivos Criados
- \`docker-compose.railway.yml\` - Configuração específica Railway
- \`railway.toml\` - Configurações da plataforma  
- \`Dockerfile\` - Container otimizado
- \`RAILWAY_SETUP.md\` - Este arquivo

## 🚀 Passos para Deploy

### 1. Fazer Push para GitHub
\`\`\`bash
git add .
git commit -m "feat: configuração Railway"
git push
\`\`\`

### 2. Deploy no Railway
1. Acesse: https://railway.app
2. Login com GitHub
3. **New Project** → **Deploy from GitHub repo**
4. Selecione este repositório
5. Railway detecta automaticamente o Docker

### 3. Adicionar Serviços
Railway Dashboard > **Add Service**:
- **PostgreSQL** (gratuito)
- **Redis** (gratuito)

### 4. Variáveis de Ambiente (Automáticas)
Railway configura automaticamente:
- \`RAILWAY_STATIC_URL\` - Seu domínio
- \`DATABASE_URL\` - PostgreSQL
- \`REDIS_URL\` - Redis

### 5. TikTok Setup (se configurado)
EOF

if [ ! -z "$TIKTOK_CLIENT_ID" ]; then
    cat >> RAILWAY_SETUP.md << EOF
**Redirect URI do TikTok:**
Após deploy, use: \`https://SEU_DOMINIO_RAILWAY/integrations/social/tiktok\`

Railway mostrará o domínio no dashboard.
EOF
else
    cat >> RAILWAY_SETUP.md << EOF
**Para configurar TikTok depois:**
1. Adicione no Railway Dashboard:
   - \`TIKTOK_CLIENT_ID\`
   - \`TIKTOK_CLIENT_SECRET\`
2. Redirect URI: \`https://SEU_DOMINIO_RAILWAY/integrations/social/tiktok\`
EOF
fi

cat >> RAILWAY_SETUP.md << EOF

## 💰 Custos
- **Grátis:** $5 crédito/mês
- **Suficiente para:** Uso pessoal e testes
- **Depois:** ~$1-3/mês para uso básico

## 📋 Comandos Úteis
\`\`\`bash
# Ver logs
railway logs

# Variáveis
railway variables

# Status
railway status
\`\`\`

## 🔗 Links
- Dashboard: https://railway.app/dashboard
- Docs: https://docs.railway.app
- Status: https://status.railway.app
EOF

echo "✅ Configuração Railway criada!"
echo
echo "📁 Arquivos criados:"
echo "   🐳 docker-compose.railway.yml"
echo "   🚂 railway.toml" 
echo "   📄 Dockerfile"
echo "   📖 RAILWAY_SETUP.md"
echo

# Fazer commit
git add .
git status

echo "🎯 Próximos passos:"
echo
echo "1. 📤 Fazer push:"
echo "   git commit -m 'feat: configuração Railway'"
echo "   git push"
echo
echo "2. 🌐 Deploy no Railway:"
echo "   • Acesse: https://railway.app"  
echo "   • New Project → Deploy from GitHub repo"
echo "   • Selecione este repositório"
echo "   • Adicione PostgreSQL e Redis"
echo
echo "3. 🎵 TikTok (se configurado):"
if [ ! -z "$TIKTOK_CLIENT_ID" ]; then
echo "   • Redirect URI: https://SEU_DOMINIO_RAILWAY/integrations/social/tiktok"
echo "   • Railway mostrará o domínio no dashboard"
else
echo "   • Configure depois no Railway Dashboard"
fi
echo
echo "📖 Detalhes completos em: RAILWAY_SETUP.md"

# Perguntar se quer fazer push agora
echo
read -p "🚀 Fazer commit e push agora? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git commit -m "feat: configuração Railway para deploy gratuito"
    
    if git push; then
        echo "✅ Push realizado com sucesso!"
        echo
        echo "🎉 Agora vá para: https://railway.app"
        echo "📋 E siga as instruções em RAILWAY_SETUP.md"
    else
        echo "❌ Erro no push. Verifique seu repositório GitHub."
    fi
else
    echo "⏸️  Push pausado. Execute quando estiver pronto:"
    echo "   git commit -m 'feat: configuração Railway'"
    echo "   git push"
fi

echo
echo "🎉 Setup Railway concluído!"
echo "💰 Custo: GRATUITO ($5 crédito/mês)"
echo "⏱️  Deploy: ~5 minutos"
