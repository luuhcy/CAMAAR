#!/bin/bash
# Script para instalar gems
cd ../backend

echo "=== INSTALANDO GEMS LOCALMENTE ==="
bundle config set --local path 'vendor/bundle'
bundle install

echo "✅ Gems instaladas com sucesso!"