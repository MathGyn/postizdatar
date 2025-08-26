# 🚨 Railway Troubleshooting - Postiz

## Problema: Healthcheck Failed

**Erro visto:**
```
1/1 replicas never became healthy!
Healthcheck failed!
```

## 🔧 Soluções

### Opção A: Configurar Variáveis Manualmente

O Railway precisa das variáveis corretas. No **Railway Dashboard**:

1. **Adicione estas variáveis de ambiente:**
   ```
   MAIN_URL=https://SEU_DOMINIO_RAILWAY.railway.app
   FRONTEND_URL=https://SEU_DOMINIO_RAILWAY.railway.app
   NEXT_PUBLIC_BACKEND_URL=https://SEU_DOMINIO_RAILWAY.railway.app/api
   JWT_SECRET=nEUzgqgNR7VqPiZecqKKNhfdrm72l8xH6AQp+hnMU6eon2y9UugBlL3+1qPWmoGK6v/O2lLoUZBqO0TfNWKb4Q==
   IS_GENERAL=true
   DISABLE_REGISTRATION=false
   STORAGE_PROVIDER=local
   UPLOAD_DIRECTORY=/uploads
   NEXT_PUBLIC_UPLOAD_DIRECTORY=/uploads
   BACKEND_INTERNAL_URL=http://localhost:3000
   PORT=5000
   ```

2. **Adicione PostgreSQL:**
   - Railway Dashboard > Add Service > PostgreSQL
   - Isso criará automaticamente `DATABASE_URL`

3. **Adicione Redis:**
   - Railway Dashboard > Add Service > Redis  
   - Isso criará automaticamente `REDIS_URL`

### Opção B: Simplificar Configuração

Vamos criar uma versão mais simples:

1. **Remover railway.toml complexo**
2. **Usar configuração básica**
3. **Deixar Railway detectar automaticamente**

### Opção C: Deploy Manual Step-by-Step

Se ainda não funcionar, tente esta abordagem:

## 🎯 Solução Recomendada: Render (100% Gratuito)

Como o Railway está dando problema, vamos tentar o **Render** que é mais simples:

### Render vs Railway:
- ✅ **Render:** 100% gratuito (com hibernação)
- ✅ **Setup mais simples**
- ✅ **PostgreSQL incluído**
- ✅ **HTTPS automático**
- ⚠️ **Hiberna após 15 min** de inatividade

## 🔄 Próximos Passos

**Escolha uma opção:**

### 1. Continuar com Railway (Ajustar configurações)
```bash
# Vamos simplificar a configuração
git add .
git commit -m "fix: simplificar configuração Railway"  
git push
```

### 2. Migrar para Render (Mais fácil)
```bash
# Vou criar configuração para Render
./render-deploy.sh  # (vou criar este script)
```

### 3. Tentar Fly.io (Alternativa técnica)
```bash
# Configuração para Fly.io
./fly-deploy.sh     # (vou criar este script)
```

## 🛠️ Debug Railway

Se quiser continuar com Railway, verifique:

1. **Logs do container:**
   - Railway Dashboard > View Logs
   - Procure por erros de startup

2. **Variáveis de ambiente:**
   - Certifique-se que `DATABASE_URL` e `REDIS_URL` estão configurados
   - Verifique se PostgreSQL e Redis foram adicionados como serviços

3. **Healthcheck:**
   - O Postiz pode demorar para inicializar
   - Tente aumentar timeout para 600s

4. **Porta:**
   - Verifique se PORT=5000 está configurado
   - Railway deve usar a porta correta

## 💡 Recomendação

**Para começar rapidamente:** Use Render
**Para produção séria:** Use DigitalOcean VPS  
**Para experimentos:** Continue Railway com ajustes

**Qual opção você prefere?**
1. Corrigir Railway  
2. Migrar para Render
3. Tentar Fly.io
