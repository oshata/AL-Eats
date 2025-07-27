#!/bin/bash

# AL Eats TrueNAS SCALE Setup Script
# Run this script on your TrueNAS SCALE system

set -e

echo "🍽️  AL Eats TrueNAS SCALE Setup"
echo "==============================="

# Get pool name from user
read -p "Enter your TrueNAS pool name (e.g., tank): " POOL_NAME

if [ -z "$POOL_NAME" ]; then
    echo "❌ Pool name is required"
    exit 1
fi

APP_DIR="/mnt/${POOL_NAME}/al-eats"

echo "📁 Creating application directory: $APP_DIR"
mkdir -p "$APP_DIR"
cd "$APP_DIR"

echo "📥 Downloading AL Eats from GitHub..."
if command -v git &> /dev/null; then
    git clone https://github.com/oshata/AL-Eats.git .
else
    echo "Git not found. Please download manually from GitHub."
    exit 1
fi

echo "🔧 Setting up permissions..."
chmod -R 755 .
mkdir -p data
chown -R 33:33 data/  # www-data user

echo "🐳 Starting AL Eats with Docker Compose..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    echo "Docker Compose not found. Please install Docker Compose or use TrueNAS Apps UI."
    exit 1
fi

echo ""
echo "✅ AL Eats setup complete!"
echo ""
echo "🌐 Access your app at: http://$(hostname -I | awk '{print $1}'):8080"
echo "📱 Add this URL to your devices' bookmarks"
echo ""
echo "🔧 To manage the container:"
echo "   docker ps                    # Check status"
echo "   docker logs al-eats         # View logs"
echo "   docker-compose restart      # Restart app"
echo "   docker-compose down         # Stop app"
echo ""
echo "🍽️ Happy restaurant hunting!"
