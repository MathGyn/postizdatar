#!/bin/bash

echo "🧪 Testing Postiz Installation..."
echo "=================================="
echo

# Test main application
echo "📱 Testing main application (http://localhost:5001)..."
MAIN_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5001)
if [ "$MAIN_RESPONSE" == "200" ] || [ "$MAIN_RESPONSE" == "307" ] || [ "$MAIN_RESPONSE" == "302" ]; then
    echo "✅ Main application is responding (HTTP $MAIN_RESPONSE)"
else
    echo "❌ Main application is not responding correctly (HTTP $MAIN_RESPONSE)"
fi

echo

# Test API endpoint
echo "🔗 Testing API endpoint (http://localhost:5001/api)..."
API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5001/api)
if [ "$API_RESPONSE" == "200" ] || [ "$API_RESPONSE" == "301" ] || [ "$API_RESPONSE" == "404" ]; then
    echo "✅ API endpoint is responding (HTTP $API_RESPONSE)"
else
    echo "❌ API endpoint is not responding correctly (HTTP $API_RESPONSE)"
fi

echo

# Check container status
echo "🐳 Checking container status..."
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

echo
echo "📋 Container logs (last 5 lines):"
echo "----------------------------------"
docker compose logs postiz | tail -5

echo
echo "🎉 Installation test complete!"
echo
echo "📍 Access Postiz at: http://localhost:5001"
echo
echo "🔧 Useful commands:"
echo "  - View logs: docker compose logs -f postiz"
echo "  - Stop services: docker compose down"
echo "  - Start services: docker compose up -d"
echo "  - Restart services: docker compose restart"
