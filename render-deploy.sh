#!/bin/bash

echo "🎨 Deploy Postiz no Render (100% GRATUITO)"
echo "==========================================="
echo

echo "💰 Render Free Tier:"
echo "   ✅ 100% Gratuito para sempre"
echo "   ✅ PostgreSQL gratuito (90 dias, depois $7/mês)"
echo "   ✅ HTTPS automático"
echo "   ✅ Domínio gratuito (.onrender.com)"
echo "   ⚠️  Hiberna após 15min de inatividade"
echo "   ⚠️  ~30s para acordar"
echo

# Perguntar se quer continuar
read -p "Migrar do Railway para Render? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "👋 Ok, vamos ficar com Railway então!"
    exit 0
fi

echo "🔧 Configurando para Render..."

# Criar render.yaml para configuração
cat > render.yaml << 'EOF'
services:
  - type: web
    name: postiz
    env: docker
    dockerfilePath: ./Dockerfile
    plan: free
    healthCheckPath: /
    envVars:
      - key: MAIN_URL
        sync: false
      - key: FRONTEND_URL  
        sync: false
      - key: NEXT_PUBLIC_BACKEND_URL
        sync: false
      - key: DATABASE_URL
        fromDatabase:
          name: postiz-postgres
          property: connectionString
      - key: JWT_SECRET
        generateValue: true
      - key: IS_GENERAL
        value: "true"
      - key: DISABLE_REGISTRATION
        value: "false"
      - key: STORAGE_PROVIDER
        value: "local"
      - key: UPLOAD_DIRECTORY
        value: "/uploads"
      - key: NEXT_PUBLIC_UPLOAD_DIRECTORY
        value: "/uploads"
      - key: BACKEND_INTERNAL_URL
        value: "http://localhost:3000"
      - key: PORT
        value: "5000"

databases:
  - name: postiz-postgres
    databaseName: postiz
    user: postiz
    plan: free
EOF

# Criar Dockerfile otimizado para Render
cat > Dockerfile.render << 'EOF'
FROM ghcr.io/gitroomhq/postiz-app:latest

# Render usa PORT automaticamente
ENV PORT=5000
ENV NODE_ENV=production

# Criar diretório de uploads
RUN mkdir -p /uploads && chmod 777 /uploads

EXPOSE 5000

# O Postiz já tem o comando correto configurado
EOF

# Criar instruções para Render
cat > RENDER_SETUP.md << 'EOF'
# 🎨 Deploy no Render - Instruções

## Arquivos Criados
- `render.yaml` - Configuração do Render
- `Dockerfile.render` - Container otimizado para Render
- `RENDER_SETUP.md` - Este arquivo

## 🚀 Deploy no Render

### 1. Fazer Push
```bash
git add .
git commit -m "feat: configuração Render"
git push
```

### 2. Deploy no Render
1. Acesse: https://render.com
2. Login com GitHub
3. **New +** > **Blueprint**
4. **Connect Repository**: Selecione seu repo
5. **Render detecta** o `render.yaml` automaticamente

### 3. Configurar URLs (Importante)
Após o deploy, no Render Dashboard:
1. Copie a URL gerada (ex: `postiz-xxxx.onrender.com`)
2. Vá em **Environment** > **Edit**
3. Configure:
   - `MAIN_URL`: https://postiz-xxxx.onrender.com
   - `FRONTEND_URL`: https://postiz-xxxx.onrender.com  
   - `NEXT_PUBLIC_BACKEND_URL`: https://postiz-xxxx.onrender.com/api

### 4. TikTok Setup
Use a URL do Render como redirect:
`https://postiz-xxxx.onrender.com/integrations/social/tiktok`

## 💰 Custos
- **Web Service:** 100% Gratuito
- **PostgreSQL:** Gratuito por 90 dias, depois $7/mês
- **Hibernação:** Sim, após 15 minutos de inatividade

## ⚠️ Limitações
- **Sleep:** App hiberna após 15min sem uso
- **Wake time:** ~30 segundos para acordar
- **Build time:** 15 minutos máximo
- **Banco:** Expira em 90 dias (precisa upgrade)

## 🔄 Acordar o App
Para manter ativo, use um serviço como:
- UptimeRobot (gratuito)
- Pingdom
- Ou acesse manualmente de vez em quando

## 📋 Comandos Úteis
```bash
# Ver logs
render logs --service=postiz

# Deploy manual
render deploy --service=postiz
```

## 🔗 Links
- Dashboard: https://dashboard.render.com
- Docs: https://render.com/docs
- Status: https://render.com/status
EOF

echo "✅ Configuração Render criada!"
echo
echo "📁 Arquivos criados:"
echo "   📄 render.yaml"
echo "   🐳 Dockerfile.render" 
echo "   📖 RENDER_SETUP.md"
echo

# Fazer commit
git add .
git status

echo "🎯 Próximos passos:"
echo
echo "1. 📤 Fazer push:"
echo "   git commit -m 'feat: configuração Render'"
echo "   git push"
echo
echo "2. 🎨 Deploy no Render:"
echo "   • Acesse: https://render.com"
echo "   • New + > Blueprint"
echo "   • Connect Repository"
echo "   • Render detecta render.yaml automaticamente"
echo
echo "3. 🔧 Configurar URLs:"
echo "   • Copie URL gerada pelo Render"
echo "   • Configure MAIN_URL, FRONTEND_URL, NEXT_PUBLIC_BACKEND_URL"
echo
echo "4. 🎵 TikTok:"
echo "   • Use https://SEU_DOMINIO_RENDER/integrations/social/tiktok"
echo
echo "📖 Detalhes completos em: RENDER_SETUP.md"

# Perguntar se quer fazer push
echo
read -p "🚀 Fazer commit e push agora? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git commit -m "feat: configuração Render como alternativa gratuita"
    
    if git push; then
        echo "✅ Push realizado com sucesso!"
        echo
        echo "🎉 Agora vá para: https://render.com"
        echo "📋 E siga as instruções em RENDER_SETUP.md"
        echo
        echo "💡 Render é mais estável que Railway para Postiz!"
    else
        echo "❌ Erro no push. Verifique a conexão."
    fi
else
    echo "⏸️  Push pausado. Execute quando estiver pronto:"
    echo "   git commit -m 'feat: configuração Render'"
    echo "   git push"
fi

echo
echo "🎨 Setup Render concluído!"
echo "💰 Custo: 100% GRATUITO (com hibernação)"
echo "⏱️  Deploy: ~10-15 minutos"
echo "🔄 Wake time: ~30 segundos após hibernar"
