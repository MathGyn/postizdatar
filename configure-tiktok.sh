#!/bin/bash

echo "🎵 Configurador de TikTok para Postiz"
echo "===================================="
echo

# Verificar se o docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Arquivo docker-compose.yml não encontrado!"
    echo "Execute este script a partir da pasta do Postiz."
    exit 1
fi

echo "📋 Para configurar o TikTok, você precisa:"
echo "1. Criar um app no TikTok Developer Portal (https://developers.tiktok.com/apps)"
echo "2. Obter o Client ID e Client Secret"
echo "3. Configurar o Redirect URI como: https://redirectmeto.com/http://localhost:5001/integrations/social/tiktok"
echo

# Perguntar se o usuário quer continuar
read -p "Você já criou o app no TikTok e tem as credenciais? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo
    echo "📚 Abra o guia TIKTOK_SETUP.md para instruções detalhadas:"
    echo "   cat TIKTOK_SETUP.md"
    echo
    echo "🌐 Acesse: https://developers.tiktok.com/apps"
    exit 0
fi

echo
echo "🔑 Insira suas credenciais do TikTok:"

# Solicitar Client ID
read -p "Client ID (16 caracteres): " CLIENT_ID
if [ ${#CLIENT_ID} -ne 16 ]; then
    echo "⚠️  Aviso: Client ID geralmente tem 16 caracteres. Você digitou ${#CLIENT_ID}."
fi

# Solicitar Client Secret
read -p "Client Secret (32 caracteres): " CLIENT_SECRET
if [ ${#CLIENT_SECRET} -ne 32 ]; then
    echo "⚠️  Aviso: Client Secret geralmente tem 32 caracteres. Você digitou ${#CLIENT_SECRET}."
fi

echo
echo "🔧 Configurando credenciais..."

# Backup do arquivo original
cp docker-compose.yml docker-compose.yml.backup
echo "📋 Backup criado: docker-compose.yml.backup"

# Atualizar o docker-compose.yml
sed -i.tmp "s|# TIKTOK_CLIENT_ID: \"seu_client_id_16_caracteres\"|TIKTOK_CLIENT_ID: \"$CLIENT_ID\"|g" docker-compose.yml
sed -i.tmp "s|# TIKTOK_CLIENT_SECRET: \"seu_client_secret_32_caracteres\"|TIKTOK_CLIENT_SECRET: \"$CLIENT_SECRET\"|g" docker-compose.yml
rm docker-compose.yml.tmp

echo "✅ Credenciais adicionadas ao docker-compose.yml"
echo

# Perguntar se quer reiniciar o Postiz
read -p "Reiniciar o Postiz agora? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Reiniciando Postiz..."
    docker compose down
    echo "⏳ Aguardando containers pararem..."
    sleep 3
    docker compose up -d
    echo "🚀 Postiz reiniciado!"
    echo
    echo "📋 Para verificar os logs:"
    echo "   docker compose logs -f postiz"
    echo
    echo "🌐 Acesse: http://localhost:5001"
    echo "   Vá em 'Add Channel' > 'TikTok' para testar"
else
    echo
    echo "⏸️  Configuração salva. Para aplicar as mudanças:"
    echo "   docker compose down"
    echo "   docker compose up -d"
fi

echo
echo "🎉 Configuração concluída!"
echo
echo "📝 Lembre-se:"
echo "   - Redirect URI no TikTok: https://redirectmeto.com/http://localhost:5001/integrations/social/tiktok"
echo "   - Permissões necessárias: user.info.basic, video.create, video.publish, video.upload, user.info.profile"
echo "   - Se houver problemas, consulte TIKTOK_SETUP.md"
