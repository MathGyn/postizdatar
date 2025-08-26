# 🎵 Configuração do TikTok no Postiz

## ❌ Problema Comum
Se você está vendo este erro:
```
Não foi possível entrar com o TikTok. Isso pode ser devido a configurações específicas do app.
Se você for um desenvolvedor, corrija o seguinte e tente novamente:
client_key
```

Isso significa que as credenciais da API do TikTok não estão configuradas no Postiz.

## ⚠️ Requisitos Importantes

**ATENÇÃO:** O TikTok tem requisitos específicos:
- ✅ Você precisa ter uma conta de desenvolvedor do TikTok
- ✅ Você precisa ter um site público com HTTPS
- ✅ O TikTok NÃO aceita URLs http:// para redirect
- ✅ Você precisa acessar o Postiz via HTTPS (não localhost HTTP)

## 🔧 Passo a Passo para Configurar

### 1️⃣ Criar Aplicação no TikTok

1. Acesse: https://developers.tiktok.com/apps
2. Clique em "Create App"
3. Preencha:
   - **App Name**: `MeuPostiz`
   - **Redirect URI**: Veja abaixo como configurar

### 2️⃣ Configurar Redirect URI

O Redirect URI segue o padrão:
```
[SEU_URL_POSTIZ]/integrations/social/tiktok
```

**Exemplos:**
- Se seu Postiz está em `https://meudominio.com`, use: 
  `https://meudominio.com/integrations/social/tiktok`
- Se está em localhost (COM HTTPS): 
  `https://localhost:5001/integrations/social/tiktok`
- Se está em localhost HTTP (usar redirect temporário): 
  `https://redirectmeto.com/http://localhost:5001/integrations/social/tiktok`

### 3️⃣ Configurar TOS e Privacy Policy

- Você precisa de uma Política de Privacidade e Termos de Serviço
- Devem estar hospedados em um site público com HTTPS
- Marque "Web" como plataforma

### 4️⃣ Adicionar Apps

1. Adicione "Login Kit"
2. Adicione "Content Posting API"
3. Para Content Posting API, habilite "Direct Post"

### 5️⃣ Adicionar Scopes (Permissões)

Marque estas permissões:
- ✅ `user.info.basic`
- ✅ `video.create`
- ✅ `video.publish` 
- ✅ `video.upload`
- ✅ `user.info.profile`

### 6️⃣ Obter Credenciais

Após criar o app, copie:
- **Client ID** (16 caracteres)
- **Client Secret** (32 caracteres)

## 🔑 Configurar Variáveis de Ambiente

Você precisa adicionar as credenciais no arquivo `docker-compose.yml`:

```yaml
environment:
  # ... outras variáveis ...
  TIKTOK_CLIENT_ID: "seu_client_id_aqui"
  TIKTOK_CLIENT_SECRET: "seu_client_secret_aqui"
```

## 🚀 Aplicar as Configurações

1. **Editar docker-compose.yml**:
   ```bash
   nano docker-compose.yml
   ```

2. **Adicionar as variáveis TikTok** na seção `environment` do serviço `postiz`

3. **Reiniciar o Postiz**:
   ```bash
   docker compose down
   docker compose up -d
   ```

4. **Verificar se reiniciou**:
   ```bash
   docker compose logs postiz | tail -10
   ```

## 🌐 Problema com Localhost e HTTP

Como o TikTok exige HTTPS, você tem algumas opções:

### Opção A: Usar um Serviço de Redirect
Use `https://redirectmeto.com/` na sua configuração do TikTok:
```
https://redirectmeto.com/http://localhost:5001/integrations/social/tiktok
```

### Opção B: Configurar HTTPS Local
Configure um certificado SSL local ou use um túnel como ngrok.

### Opção C: Usar um Domínio Real
Configure o Postiz em um servidor com domínio real e HTTPS.

## ✅ Testar a Configuração

1. Acesse o Postiz: http://localhost:5001
2. Vá em "Add Channel" 
3. Selecione "TikTok"
4. Você deve ser redirecionado para a autorização do TikTok

## 🆘 Resolução de Problemas

### Erro: "client_key"
- ✅ Verifique se `TIKTOK_CLIENT_ID` está configurado
- ✅ Reinicie o Postiz após adicionar as variáveis

### Erro de Redirect URI
- ✅ Verifique se o Redirect URI no TikTok está exatamente igual
- ✅ Certifique-se de usar HTTPS na configuração do TikTok

### App não aprovado
- ✅ O TikTok pode exigir revisão manual do seu app
- ✅ Certifique-se de ter TOS e Privacy Policy válidos

## 📝 Exemplo Completo

Seu `docker-compose.yml` deve ter algo assim:

```yaml
services:
  postiz:
    image: ghcr.io/gitroomhq/postiz-app:latest
    environment:
      MAIN_URL: "http://localhost:5001"
      FRONTEND_URL: "http://localhost:5001"
      NEXT_PUBLIC_BACKEND_URL: "http://localhost:5001/api"
      JWT_SECRET: "seu_jwt_secret"
      # ... outras variáveis ...
      
      # CREDENCIAIS TIKTOK
      TIKTOK_CLIENT_ID: "1234567890123456"
      TIKTOK_CLIENT_SECRET: "12345678901234567890123456789012"
```

Depois de configurar, reinicie:
```bash
docker compose down && docker compose up -d
```

## 🔗 Links Úteis

- [TikTok Developer Portal](https://developers.tiktok.com/apps)
- [Documentação Oficial Postiz](https://docs.postiz.com/providers/tiktok)
- [RedirectMeTo (para localhost)](https://redirectmeto.com/)

---

**Nota:** O TikTok é uma das integrações mais complexas devido aos requisitos de HTTPS e verificação de domínio. Para desenvolvimento local, considere usar outras plataformas primeiro.
