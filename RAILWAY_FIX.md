# 🔧 Fix Railway - Erro 502 Resolvido

## ❌ **Problema Identificado**
O erro 502 Bad Gateway aconteceu porque:
1. Railway não usa docker-compose, apenas Dockerfile
2. Configuração de porta estava incorreta
3. Healthcheck apontando para endpoint errado
4. Credenciais TikTok inválidas

## ✅ **Correções Aplicadas**

### 1. Dockerfile Corrigido
- Script personalizado para Railway
- Porta dinâmica ($PORT)
- Configuração automática de URLs

### 2. Script start-railway.sh
- Configura variáveis automaticamente
- Aguarda banco estar disponível
- Inicia na porta correta do Railway

### 3. railway.toml Atualizado
- Healthcheck para `/api/health`
- Configurações básicas incluídas

## 🚀 **Como Aplicar a Correção**

### 1. Fazer Commit das Correções
```bash
git add .
git commit -m "fix: corrigir configuração Railway - resolver erro 502"
git push
```

### 2. Redeploy no Railway
1. Vá ao Railway Dashboard
2. Seu projeto fará redeploy automaticamente
3. Aguarde ~3-5 minutos

### 3. Verificar Variáveis no Railway
**Obrigatórias (Railway adiciona automaticamente):**
- ✅ `DATABASE_URL` - PostgreSQL
- ✅ `REDIS_URL` - Redis  
- ✅ `RAILWAY_STATIC_URL` - Seu domínio
- ✅ `PORT` - Porta dinâmica

**Adicionar manualmente:**
- `JWT_SECRET` - (já incluído)
- `IS_GENERAL` - `true`
- `STORAGE_PROVIDER` - `local`

### 4. TikTok (Opcional - Depois que funcionar)
**Adicionar no Railway Dashboard > Variables:**
- `TIKTOK_CLIENT_ID` - Seu Client ID real
- `TIKTOK_CLIENT_SECRET` - Seu Client Secret real

## 🔍 **Verificações**

### Logs do Railway
Você deve ver:
```
🚂 Iniciando Postiz no Railway...
📡 Usando porta: 12345
🌐 URLs configuradas para: https://seuapp.up.railway.app
🔧 Variáveis configuradas...
🚀 Iniciando Postiz...
```

### Status
- ✅ Build: Success
- ✅ Deploy: Success  
- ✅ Healthcheck: `/api/health` retorna 200
- ✅ Site acessível

## 🎯 **Próximos Passos Após Fix**

1. **Testar acesso:** https://seudominio.up.railway.app
2. **Criar primeiro usuário**
3. **Configurar TikTok** (se desejar)
4. **Adicionar outras redes sociais**

## 🆘 **Se Ainda Houver Erro**

### Ver logs detalhados:
```bash
# No Railway Dashboard
View Logs > Deploy Logs
```

### Problemas comuns:
- **Banco não conecta:** Aguarde 1-2 min, Railway precisa provisionar
- **Ainda 502:** Verifique se todas variáveis estão configuradas
- **Build falha:** Verifique se arquivos foram commitados

## ✅ **Resultado Esperado**
Após aplicar as correções:
- ✅ Deploy sem erro 502
- ✅ Healthcheck passa
- ✅ Site acessível via HTTPS
- ✅ Pronto para configurar TikTok

**Execute o commit agora para aplicar as correções!**
