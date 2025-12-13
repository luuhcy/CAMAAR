#!/bin/bash
# Script para rodar testes
set -e
cd ../backend

echo "=== PREPARANDO BANCO DE TESTE ==="
bundle exec rails db:create RAILS_ENV=test 2>/dev/null || true
bundle exec rails db:migrate RAILS_ENV=test 2>/dev/null || true
echo "Banco preparado!"

echo "\n=== RODANDO TESTES ==="
bundle exec rspec ../rspec --format documentation --color

echo "\n=== RESUMO ==="
echo "✅ Testes concluídos!"
echo "📁 Arquivos testados: turma, student, user, controllers"