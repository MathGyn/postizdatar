# 🚂 Deploy no Railway - Instruções

## Arquivos Criados
- `docker-compose.railway.yml` - Configuração específica Railway
- `railway.toml` - Configurações da plataforma  
- `Dockerfile` - Container otimizado
- `RAILWAY_SETUP.md` - Este arquivo

## 🚀 Passos para Deploy

### 1. Fazer Push para GitHub
```bash
git add .
git commit -m "feat: configuração Railway"
git push
```

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
- `RAILWAY_STATIC_URL` - Seu domínio
- `DATABASE_URL` - PostgreSQL
- `REDIS_URL` - Redis

### 5. TikTok Setup (se configurado)
**Redirect URI do TikTok:**
Após deploy, use: `https://SEU_DOMINIO_RAILWAY/integrations/social/tiktok`

Railway mostrará o domínio no dashboard.

## 💰 Custos
- **Grátis:**  crédito/mês
- **Suficiente para:** Uso pessoal e testes
- **Depois:** ~-3/mês para uso básico

## 📋 Comandos Úteis
```bash
# Ver logs
railway logs

# Variáveis
railway variables

# Status
railway status
```

## 🔗 Links
- Dashboard: https://railway.app/dashboard
- Docs: https://docs.railway.app
- Status: https://status.railway.app
