# CAMAAR
Sistema para avaliação de atividades acadêmicas remotas do CIC.

## Visão Geral Rápida
- Backend: Ruby on Rails API para gestão de turmas, alunos e formulários de avaliação.
- Frontend: Nuxt (Vue) para interface web (login, importação de CSV, gestão/admin).
- Banco: SQLite para desenvolvimento local.

## Dependências
- Ruby 3.3.0 (via rbenv ou asdf/mise)
- Node.js 18+ e npm
- Bundler (`gem install bundler`)
- SQLite3 (biblioteca e binário do cliente)
- Gems de teste (já incluídas no Gemfile):
  - `rspec-rails` — framework de testes
  - `factory_bot_rails` — fixtures para testes
  - `shoulda-matchers` — matchers para validações e associações

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
- `bundle exec rspec` — roda todos os testes RSpec (do diretório backend)
- `bash rspec/run-tests.sh` — script para rodar testes do diretório rspec/

## Notas
- Certifique-se de que Ruby 3.3.0 está ativo antes de instalar gems.
- Se usar Windows, mantenha o terminal em UTF-8 para evitar erros de encoding em CSV.
