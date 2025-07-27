#!/bin/bash

# AL Eats Health Check Script

APP_URL="http://localhost:8080"
API_URL="$APP_URL/api.php"

echo "🏥 AL Eats Health Check"
echo "======================"

# Check if container is running
if docker ps | grep -q "al-eats"; then
    echo "✅ Container is running"
else
    echo "❌ Container is not running"
    exit 1
fi

# Check if web app is responding
if curl -s -f "$APP_URL" > /dev/null; then
    echo "✅ Web application is responding"
else
    echo "❌ Web application is not responding"
    exit 1
fi

# Check if API is responding
if curl -s -f "$API_URL" > /dev/null; then
    echo "✅ API is responding"
else
    echo "❌ API is not responding"
    exit 1
fi

# Check data directory permissions
if [ -w "data/" ]; then
    echo "✅ Data directory is writable"
else
    echo "❌ Data directory is not writable"
    exit 1
fi

echo ""
echo "🎉 All checks passed! AL Eats is healthy."
