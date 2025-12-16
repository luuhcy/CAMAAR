#!/bin/bash
# Script para instalar gems e configurar ambiente de testes
cd ../backend

echo "=== INSTALANDO GEMS LOCALMENTE ==="
bundle config set --local path 'vendor/bundle'
rm -rf vendor/bundle
bundle install

echo "=== INSTALANDO EXECUTÁVEIS DAS GEMS ==="
bundle binstubs rspec-core --force
bundle binstubs railties --force

echo "=== CONFIGURANDO BANCO DE TESTE ==="
RAILS_ENV=test bundle exec rails db:create 2>/dev/null || true
RAILS_ENV=test bundle exec rails db:migrate 2>/dev/null || true

echo "✅ Ambiente de testes configurado com sucesso!"
echo "📋 Para rodar os testes, use: bash run-tests-simple.sh"