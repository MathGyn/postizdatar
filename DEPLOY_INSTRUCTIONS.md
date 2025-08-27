# 📋 Instruções de Deploy

## Arquivos Criados

- `docker-compose.prod.yml` - Configuração de produção
- `.env.production` - Variáveis sensíveis (NÃO COMMITAR)
- `deploy.sh` - Script de deploy
- `DEPLOY_INSTRUCTIONS.md` - Este arquivo

## Configurações

- **Domínio:** https://datarmath
- **TikTok Redirect URI:** https://datarmath/integrations/social/tiktok
- **Segurança:** Habilitada (HTTPS obrigatório)
- **Registro:** Desabilitado após primeiro usuário

## Deploy em VPS/Servidor

1. Fazer upload dos arquivos:
   ```bash
   scp docker-compose.prod.yml deploy.sh root@SEU_IP:/root/postiz/
   ```

2. No servidor:
   ```bash
   cd /root/postiz
   ./deploy.sh
   ```

## Deploy em Railway/Render

1. Fazer push para GitHub:
   ```bash
   git add .
   git commit -m "feat: configuração para produção"
   git push
   ```

2. Conectar repositório na plataforma
3. Usar `docker-compose.prod.yml` como configuração

## Configuração DNS

Configure seu domínio para apontar para o servidor:
- **Tipo:** A
- **Nome:** @ ou postiz
- **Valor:** IP_DO_SERVIDOR

## Primeiro Acesso

1. Acesse: https://datarmath
2. Crie sua conta (primeira pessoa)
3. O registro será automaticamente desabilitado

## TikTok

- **Configurado:** ❌ Não configurado
- Para configurar depois, edite `docker-compose.prod.yml` e adicione:
  ```yaml
  TIKTOK_CLIENT_ID: "seu_client_id"
  TIKTOK_CLIENT_SECRET: "seu_client_secret"
  ```

## Comandos Úteis

```bash
# Ver status
docker compose -f docker-compose.prod.yml ps

# Ver logs
docker compose -f docker-compose.prod.yml logs -f postiz

# Reiniciar
docker compose -f docker-compose.prod.yml restart

# Backup
docker compose -f docker-compose.prod.yml exec postiz-postgres pg_dump -U postiz-user postiz-db-local > backup.sql
```
