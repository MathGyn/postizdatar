# 💰 Opções GRATUITAS para Hospedar Postiz

## 🆓 **Top 5 Plataformas com Free Tier**

### 1️⃣ **Railway** ⭐ **MELHOR OPÇÃO**
- 💰 **Free Tier:** $5 crédito/mês (suficiente para Postiz pequeno)
- ✅ **Vantagens:**
  - Deploy automático via GitHub
  - HTTPS automático
  - Domínio gratuito (.railway.app)
  - Banco PostgreSQL incluso
  - Interface muito simples
  - Suporte nativo ao Docker Compose
- ⚠️ **Limitações:**
  - Após $5, você paga pelo uso
  - Sleep após inatividade
- 🎯 **Ideal para:** Testes e uso pessoal

### 2️⃣ **Render** 
- 💰 **Free Tier:** Totalmente gratuito
- ✅ **Vantagens:**
  - HTTPS automático
  - Domínio gratuito (.onrender.com)
  - PostgreSQL gratuito (90 dias)
  - Deploy via GitHub
- ⚠️ **Limitações:**
  - Sleep após 15 min de inatividade
  - Banco expira em 90 dias (depois $7/mês)
  - Mais lento que Railway
- 🎯 **Ideal para:** Demos e testes rápidos

### 3️⃣ **Fly.io**
- 💰 **Free Tier:** 3 VMs gratuitas (256MB cada)
- ✅ **Vantagens:**
  - Não hiberna
  - Ótima para Docker
  - HTTPS automático
  - Global edge locations
- ⚠️ **Limitações:**
  - Configuração mais técnica
  - 256MB RAM pode ser pouco
  - Banco PostgreSQL pago
- 🎯 **Ideal para:** Desenvolvedores experientes

### 4️⃣ **Supabase** (Para banco) + **Vercel/Netlify** (Para app)
- 💰 **Free Tier:** Banco gratuito + hosting gratuito
- ✅ **Vantagens:**
  - PostgreSQL robusto e gratuito
  - Sem expiração do banco
  - HTTPS automático
- ⚠️ **Limitações:**
  - Configuração mais complexa
  - Precisa separar frontend/backend
- 🎯 **Ideal para:** Soluções híbridas

### 5️⃣ **PlanetScale** (Banco) + **Railway** (App)
- 💰 **Free Tier:** Banco MySQL gratuito
- ✅ **Vantagens:**
  - Banco escalável
  - Branching do banco
- ⚠️ **Limitações:**
  - MySQL em vez de PostgreSQL
  - Configuração mais complexa

## 🏆 **RECOMENDAÇÃO: Railway**

**Por que Railway é o melhor para Postiz:**

```yaml
✅ Setup em 5 minutos
✅ $5/mês gratuito (suficiente para começar)
✅ PostgreSQL incluído
✅ Redis incluído  
✅ Deploy automático do GitHub
✅ HTTPS + domínio automático
✅ Suporte nativo Docker Compose
✅ Logs em tempo real
✅ Zero configuração de servidor
```

## 🚀 **Tutorial: Deploy no Railway (GRATUITO)**

### Passo 1: Preparar Repositório

```bash
# Execute o script de preparação
./prepare-production.sh

# Quando perguntado sobre domínio, use:
# seuprojeto.up.railway.app (Railway gera automaticamente)

# Fazer commit
git add .
git commit -m "feat: configuração para produção Railway"
git push
```

### Passo 2: Deploy no Railway

1. **Acesse:** https://railway.app
2. **Login com GitHub**
3. **New Project** → **Deploy from GitHub repo**
4. **Selecione seu repositório**
5. **Railway detecta Docker automaticamente**

### Passo 3: Configurar Variáveis

No Railway Dashboard:
- Adicione as variáveis do arquivo `.env.production`
- Railway gera PostgreSQL automaticamente
- Redis também incluído

### Passo 4: Obter URL

Railway gera automaticamente:
`https://seuprojeto-production-XXXX.up.railway.app`

## 💡 **Setup Completo Railway (Gratuito)**

Vou criar um script específico para Railway:

```bash
#!/bin/bash
# railway-setup.sh

echo "🚂 Configurando Postiz para Railway (GRATUITO)"

# Preparar para Railway
./prepare-production.sh

# Criar railway.json
cat > railway.json << EOF
{
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "Dockerfile"
  },
  "deploy": {
    "startCommand": "docker-compose -f docker-compose.prod.yml up",
    "healthcheckPath": "/",
    "healthcheckTimeout": 100,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
EOF

echo "✅ Pronto para Railway!"
echo "📋 Próximos passos:"
echo "1. git push"
echo "2. Conectar repositório no railway.app"
echo "3. Adicionar variáveis de ambiente"
echo "4. Deploy automático!"
```

## 🔍 **Comparação de Custos**

| Plataforma | Grátis | Após Limite | Ideal Para |
|------------|--------|------------|------------|
| **Railway** | $5/mês | $0.01/minuto | ✅ **Recomendado** |
| **Render** | 100% | $7/mês (banco) | Demos |
| **Fly.io** | 3 VMs | $2.67/GB RAM | Desenvolvedores |
| **Vercel** | Unlimited | $20/mês pro | Frontends |
| **Supabase** | 500MB DB | $25/mês pro | Bancos |

## 🎯 **Minha Recomendação Final**

**Para começar GRATUITAMENTE:**

1. **Railway** - Melhor custo/benefício
2. **Render** - Se quiser 100% grátis (temporário)
3. **Fly.io** - Se souber configurar

**Railway permite:**
- ✅ Começar grátis ($5 crédito)
- ✅ Crescer conforme uso
- ✅ TikTok funciona perfeitamente
- ✅ HTTPS automático
- ✅ Deploy em 5 minutos

## 🚂 **Quer tentar Railway?**

Execute:
```bash
./prepare-production.sh
```

E quando perguntado sobre domínio, use:
`meupostiz.up.railway.app` (ou qualquer nome)

Railway vai gerar o domínio real automaticamente!

**Posso te ajudar com o setup do Railway agora?**
