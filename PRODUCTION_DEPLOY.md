# 🚀 Deploy do Postiz em Produção

## 🌐 Opções de Deploy

### 1️⃣ **VPS/Servidor Próprio** (Recomendado)
- ✅ Controle total
- ✅ Mais barato a longo prazo
- ✅ Fácil configurar HTTPS
- 💰 Custo: ~$5-20/mês

**Provedores Recomendados:**
- **DigitalOcean** - Droplet ($4-6/mês)
- **Linode** - VPS ($5/mês)
- **Vultr** - Cloud Compute ($3.50-6/mês)
- **Hetzner** - Cloud Server (€3.29/mês)
- **AWS EC2** - t3.micro/small

### 2️⃣ **Plataformas Cloud** (Mais Simples)
- ✅ Deploy automático
- ✅ HTTPS incluído
- ✅ Domínio gratuito
- 💰 Custo: Gratuito a $20/mês

**Opções:**
- **Railway** - Deploy direto do GitHub
- **Render** - Plano gratuito disponível
- **Fly.io** - Boa para Docker
- **Heroku** - Clássico (mais caro)

### 3️⃣ **Coolify** (Auto-hospedado)
- ✅ Interface visual
- ✅ SSL automático
- ✅ Backup automático
- 💰 Custo: Só do servidor

## 🔧 Configuração para Produção

### Mudanças Necessárias no `docker-compose.yml`:

```yaml
services:
  postiz:
    image: ghcr.io/gitroomhq/postiz-app:latest
    container_name: postiz
    restart: always
    environment:
      # URLs de produção - SUBSTITUA SEU DOMÍNIO
      MAIN_URL: "https://seudominio.com"
      FRONTEND_URL: "https://seudominio.com"
      NEXT_PUBLIC_BACKEND_URL: "https://seudominio.com/api"
      
      JWT_SECRET: "seu_jwt_secret_super_seguro"
      
      # Database e Redis
      DATABASE_URL: "postgresql://postiz-user:senha_forte_aqui@postiz-postgres:5432/postiz-db"
      REDIS_URL: "redis://postiz-redis:6379"
      BACKEND_INTERNAL_URL: "http://localhost:3000"
      
      IS_GENERAL: "true"
      DISABLE_REGISTRATION: "true" # Importante: Desabilitar após primeiro usuário
      
      # Storage para produção
      STORAGE_PROVIDER: "local" # ou "s3", "r2"
      UPLOAD_DIRECTORY: "/uploads"
      NEXT_PUBLIC_UPLOAD_DIRECTORY: "/uploads"
      
      # REMOVER EM PRODUÇÃO - só para desenvolvimento
      # NOT_SECURED: "true"
      
      # Credenciais TikTok
      TIKTOK_CLIENT_ID: "seu_client_id"
      TIKTOK_CLIENT_SECRET: "seu_client_secret"
      
    volumes:
      - postiz-config:/config/
      - postiz-uploads:/uploads/
    ports:
      - "80:5000" # ou use reverse proxy
    networks:
      - postiz-network
    depends_on:
      postiz-postgres:
        condition: service_healthy
      postiz-redis:
        condition: service_healthy

  # ... resto da configuração igual
```

## 🌊 Opção 1: DigitalOcean + Caddy (Recomendado)

### Passo a Passo Completo:

1. **Criar Droplet no DigitalOcean**
   - Ubuntu 22.04 LTS
   - Tamanho: Basic $6/mês (1GB RAM)
   - Adicionar sua chave SSH

2. **Conectar ao servidor**
   ```bash
   ssh root@seu_ip_do_servidor
   ```

3. **Instalar Docker**
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   ```

4. **Configurar domínio**
   - Comprar domínio (Namecheap, GoDaddy, etc.)
   - Apontar DNS A record para IP do servidor
   - Exemplo: `postiz.seudominio.com` → `IP_DO_SERVIDOR`

5. **Fazer upload dos arquivos**
   ```bash
   scp -r /Users/matheus/postiz-selfhost root@SEU_IP:/root/postiz
   ```

6. **Configurar HTTPS com Caddy**

## 🎯 Opção 2: Railway (Mais Simples)

### Deploy Automático:

1. **Fazer push para GitHub**
   ```bash
   # No seu Mac
   git add .
   git commit -m "feat: configuração para produção"
   git remote add origin https://github.com/seuusuario/postiz-selfhost.git
   git push -u origin main
   ```

2. **Deploy no Railway**
   - Acesse: https://railway.app
   - Conecte GitHub
   - Deploy from repo
   - Adicione variáveis de ambiente
   - Railway gera domínio automático

## 🛡️ Configuração de Segurança

### Variáveis Essenciais para Produção:

```bash
# URLs - OBRIGATÓRIO MUDAR
MAIN_URL=https://seudominio.com
FRONTEND_URL=https://seudominio.com
NEXT_PUBLIC_BACKEND_URL=https://seudominio.com/api

# Segurança - GERAR NOVAS
JWT_SECRET=$(openssl rand -base64 64)
DATABASE_URL=postgresql://postiz:$(openssl rand -hex 16)@postiz-postgres:5432/postiz

# Configurações importantes
DISABLE_REGISTRATION=true
IS_GENERAL=true

# Remover para produção
# NOT_SECURED=true
```

## 🔗 TikTok em Produção

Com domínio real, o TikTok fica simples:

1. **Redirect URI**: `https://seudominio.com/integrations/social/tiktok`
2. **Configurar HTTPS** (automático com Railway/Render)
3. **Adicionar credenciais** nas variáveis de ambiente

## 📋 Script de Deploy

Vou criar um script para facilitar:

```bash
#!/bin/bash
# deploy-production.sh

echo "🚀 Preparando Postiz para Produção"
echo "=================================="

read -p "Digite seu domínio (ex: postiz.seusite.com): " DOMAIN

# Criar versão de produção
cp docker-compose.yml docker-compose.prod.yml

# Atualizar URLs
sed -i "s|http://localhost:5001|https://$DOMAIN|g" docker-compose.prod.yml
sed -i "s|NOT_SECURED: \"true\"|# NOT_SECURED: \"true\" # Removido para produção|g" docker-compose.prod.yml
sed -i "s|DISABLE_REGISTRATION: \"false\"|DISABLE_REGISTRATION: \"true\"|g" docker-compose.prod.yml

echo "✅ Configuração de produção criada: docker-compose.prod.yml"
echo "🌐 Domínio configurado: https://$DOMAIN"
echo "🔒 Segurança habilitada"
```

## 🎯 Qual Opção Escolher?

**Para iniciantes:** Railway ou Render
**Para controle total:** DigitalOcean + Caddy
**Para múltiplos apps:** Coolify

Qual opção você prefere? Posso ajudar com o setup específico!

## 📞 Próximos Passos

1. **Escolher plataforma de deploy**
2. **Configurar domínio**
3. **Ajustar docker-compose para produção**
4. **Configurar TikTok com URL real**
5. **Fazer primeiro deploy**

Qual plataforma você gostaria de usar?
