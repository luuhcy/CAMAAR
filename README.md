# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC.

## Visão Geral Rápida
- Backend: Ruby on Rails API para gestão de turmas, alunos e formulários de avaliação.
- Frontend: Nuxt (Vue) para interface web (login, importação de CSV, gestão/admin).
- Banco: SQLite para desenvolvimento local.

## Dependências

### Backend
- **Ruby 3.3.0** (via rbenv, asdf ou mise)
- **Bundler** (`gem install bundler`)
- **SQLite3** (biblioteca e binário do cliente)
- **Rails 8.0.4** (instalado via bundle)

### Gems de Teste (incluídas no Gemfile)
- `rspec-rails` (v8.0+) — Framework de testes BDD
- `factory_bot_rails` — Criação de fixtures para testes
- `shoulda-matchers` — Matchers para validações e associações
- `simplecov` — Relatório de cobertura de código

### Frontend
- **Node.js 18+** e npm
- **Nuxt 3** (instalado via npm)

## Configuração Rápida
### 1) Clonar e instalar backend
```bash
git clone https://github.com/luuhcy/CAMAAR.git
cd CAMAAR/backend
bundle install
cp config/database.yml config/database.yml.local || true
rails db:migrate db:seed
```

### 2) Rodar backend (porta 3001)
```bash
cd backend
rails s -p 3001
```

### 3) Instalar e rodar frontend
```bash
cd ../frontend
npm install
npm run dev
```

### 4) Importar CSV (admin)
- Importação disponível na interface; ou
- Endpoint: `POST http://localhost:3001/admin/importar`
- Campo de formulário: `csvFile`
- Formato: `codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno`
- Encoding: UTF-8 preferencial (fallback Latin1 suportado)

## Estrutura
- `backend/` Rails API
- `frontend/` Nuxt app
- `VALIDACOES_TURMAS_ALUNOS.md` detalhes de regras de negócio

## Scripts úteis
- `rails db:seed` — popula dados iniciais
- `rails db:migrate` — aplica migrations
- `npm run dev` — executa frontend em modo dev

## Testes

### Configuração do Ambiente de Testes

Para executar os testes, todas as dependências de teste já estão incluídas no `Gemfile`. Certifique-se de que o ambiente está configurado:

```bash
cd backend
bundle install
```

### Preparar Banco de Dados de Teste

Antes de executar os testes pela primeira vez:

```bash
cd backend
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate
```

### Executar Todos os Testes

```bash
cd backend
bundle exec rspec spec --format documentation
```

### Executar Testes Específicos

```bash
# Testar apenas um arquivo
bundle exec rspec spec/models/user_spec.rb

# Testar apenas um controller
bundle exec rspec spec/controllers/students_controller_spec.rb

# Executar teste específico por linha
bundle exec rspec spec/models/user_spec.rb:15
```

### Formato de Saída

```bash
# Formato detalhado (documentation)
bundle exec rspec spec --format documentation

# Formato resumido (progress)
bundle exec rspec spec --format progress

# Com cores
bundle exec rspec spec --format documentation --color
```

### Relatório de Cobertura

Após executar os testes, um relatório de cobertura é gerado automaticamente:

```bash
# Executar testes
bundle exec rspec spec

# Visualizar relatório de cobertura
open backend/coverage/index.html  # macOS
xdg-open backend/coverage/index.html  # Linux
start backend/coverage/index.html  # Windows
```

A cobertura atual do projeto é de **95.4%**.

### Script Automatizado

Um script bash está disponível para executar todos os testes com configuração automática:

```bash
cd rspec
bash run-tests-simple.sh
```

Este script:
- Configura o banco de dados de teste automaticamente
- Executa todos os testes
- Exibe relatório de cobertura
- Mostra resumo colorido dos resultados

### Estrutura dos Testes

Os testes estão organizados em `backend/spec/`:

#### Models
- `user_spec.rb` — Validações, autenticação e relacionamentos
- `student_spec.rb` — Validações de aluno e unicidade
- `turma_spec.rb` — Validações de turma e duplicatas
- `template_spec.rb` — Templates e questões associadas
- `formulario_spec.rb` — Formulários e respostas
- `questao_spec.rb` — Tipos de questões e validações
- `respostum_spec.rb` — Respostas e serialização JSON

#### Controllers
- `users_controller_spec.rb` — CRUD de usuários
- `students_controller_spec.rb` — CRUD de alunos
- `turmas_controller_spec.rb` — CRUD de turmas
- `templates_controller_spec.rb` — CRUD de templates
- `formularios_controller_spec.rb` — CRUD de formulários
- `questaos_controller_spec.rb` — CRUD de questões
- `respostas_controller_spec.rb` — CRUD de respostas
- `sessions_controller_spec.rb` — Autenticação e login
- `importar_controller_spec.rb` — Importação de CSV

#### Tipos de Testes

**Happy Path** ✅
- Criação, atualização e exclusão com dados válidos
- Listagem de recursos
- Autenticação bem-sucedida
- Operações corretas de CRUD

**Sad Path** ❌
- Validações falhando (campos obrigatórios, formatos inválidos)
- Recursos não encontrados (404)
- Dados duplicados (unicidade)
- Autenticação falha
- Parâmetros inválidos ou ausentes

**Edge Cases** 🔧
- Strings vazias vs nil
- Caracteres especiais
- Datas extremas (passado/futuro distante)
- JSON complexo e dados vazios
- Tentativas de SQL injection
- Tamanhos limites de strings

### Dependências de Teste

Certifique-se de que as seguintes gems estão no `Gemfile` (grupo `:test`):

```ruby
group :development, :test do
  gem 'rspec-rails', '~> 8.0'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
end
```

### Configuração do RSpec

O arquivo `spec/rails_helper.rb` já está configurado com:
- SimpleCov para cobertura de código
- Shoulda Matchers para validações
- Factory Bot para fixtures
- Transactional fixtures habilitadas
- Suporte a fixture files

### Executar Testes em CI/CD

Para ambientes de integração contínua:

```bash
#!/bin/bash
cd backend
bundle install --jobs=4 --retry=3
RAILS_ENV=test bundle exec rails db:create db:migrate
bundle exec rspec spec --format progress --format RspecJunitFormatter --out rspec.xml
```

## Notas
- Certifique-se de que Ruby 3.3.0 está ativo antes de instalar gems.
- Se usar Windows, mantenha o terminal em UTF-8 para evitar erros de encoding em CSV.
