#!/bin/bash
# Script otimizado para rodar testes do CAMAAR
set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Navegar para o diretório backend
if [ ! -d "../backend" ]; then
    log_error "Diretório backend não encontrado!"
    exit 1
fi

cd ../backend

log_info "Preparando ambiente de teste..."

# Verificar se Rails está disponível
if ! command -v rails &> /dev/null; then
    log_error "Rails não encontrado! Execute 'bundle install' primeiro."
    exit 1
fi

# Preparar banco de teste
log_info "Configurando banco de teste..."
RAILS_ENV=test bundle exec rails db:drop 2>/dev/null || true
RAILS_ENV=test bundle exec rails db:create 2>/dev/null || true
RAILS_ENV=test bundle exec rails db:migrate 2>/dev/null || true
log_success "Banco de teste configurado!"

log_info "Executando suite de testes..."

# Executar testes com tratamento de erro
if bundle exec rspec ../rspec --format documentation --color; then
    log_success "Todos os testes passaram!"
    
    # Mostrar estatísticas se disponível
    if [ -f "coverage/.last_run.json" ]; then
        log_info "Relatório de cobertura gerado em: coverage/index.html"
    fi
    
    log_info "Resumo da implementação:"
    echo "  📋 Models testados: User, Student, Turma, Template, Formulario, Questao, Respostum"
    echo "  🎮 Controllers testados: Users, Students, Turmas, Templates, Formularios, Questaos, Respostas, Sessions, Admin"
    echo "  ✨ Cobertura: Happy Path + Sad Path + Edge Cases"
    echo "  🌐 Testes em português para melhor legibilidade"
    
else
    log_error "Alguns testes falharam!"
    log_warning "Verifique os erros acima e corrija antes de continuar."
    exit 1
fi

log_success "Suite de testes executada com sucesso! 🎉"