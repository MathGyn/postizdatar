#!/bin/bash
echo "🚀 Fazendo deploy do Postiz..."

# Parar serviços se estiverem rodando
docker compose -f docker-compose.prod.yml down 2>/dev/null || true

# Fazer pull das imagens mais recentes
docker compose -f docker-compose.prod.yml pull

# Iniciar serviços
docker compose -f docker-compose.prod.yml up -d

echo "✅ Deploy concluído!"
echo "📋 Para verificar status: docker compose -f docker-compose.prod.yml ps"
echo "📋 Para ver logs: docker compose -f docker-compose.prod.yml logs -f postiz"
