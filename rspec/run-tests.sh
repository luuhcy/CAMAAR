#!/bin/bash
# Script pra rodar os testes
set -e
cd ../backend

# Roda as migrations do banco de teste
bundle exec rails db:migrate RAILS_ENV=test 2>/dev/null || true

# Roda os testes com output detalhado
bundle exec rspec ../rspec --format documentation
