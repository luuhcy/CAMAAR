# Validações de Turmas e Alunos

## Regras de Negócio Implementadas

### 1. Unicidade de Turmas
- **Regra**: Uma turma é identificada de forma única pela combinação de `codigo_sigaa` + `semestre`
- **Implicação**: Pode haver turmas com o mesmo `codigo_sigaa` em semestres **diferentes**
- **Validação em Nível de Banco**: Índice único composto `[codigo_sigaa, semestre]`
- **Validação em Nível de Modelo**: `validates :codigo_sigaa, uniqueness: { scope: :semestre }`

**Exemplos permitidos:**
```
Turma 1: codigo_sigaa=CS101, semestre="1º/2024"
Turma 2: codigo_sigaa=CS101, semestre="2º/2024" ✅ PERMITIDO (mesmo código, semestre diferente)
Turma 3: codigo_sigaa=CS102, semestre="1º/2024" ✅ PERMITIDO (código diferente)
```

**Exemplo NÃO permitido:**
```
Turma 1: codigo_sigaa=CS101, semestre="1º/2024"
Turma 2: codigo_sigaa=CS101, semestre="1º/2024" ❌ ERRO: Turma já existe
```

---

### 2. Matrícula Única de Alunos
- **Regra**: Um aluno não pode estar matriculado em **duas turmas iguais** no mesmo semestre
- **Definição de "turma igual"**: Mesmo `codigo_sigaa` e mesmo `semestre`
- **Implicação**: Um aluno **pode** estar na mesma turma em semestres **diferentes**
- **Validação em Nível de Modelo**: Custom validation `unique_turma_per_semester` com proc

**Exemplos permitidos:**
```
Aluno: Matrícula=20240001, Nome=João Silva

Registro 1: turma=CS101 (1º/2024)
Registro 2: turma=CS101 (2º/2024) ✅ PERMITIDO (mesmo código/disciplina, semestre diferente)
Registro 3: turma=CS102 (1º/2024) ✅ PERMITIDO (código diferente)
```

**Exemplo NÃO permitido:**
```
Aluno: Matrícula=20240001, Nome=João Silva

Registro 1: turma=CS101 (1º/2024)
Registro 2: turma=CS101 (1º/2024) ❌ ERRO: Aluno já matriculado em outra turma com mesmo código neste semestre
```

---

## Implementação Técnica

### Modelo: Turma
**Arquivo**: `/backend/app/models/turma.rb`

```ruby
class Turma < ApplicationRecord
  has_many :students, dependent: :destroy  # Deleta alunos quando turma é deletada
  has_many :formularios

  before_validation :set_ano_from_semestre

  validates :codigo_sigaa, presence: true
  validates :semestre, presence: true
  # Uma turma é única pela combinação de codigo_sigaa + semestre
  validates :codigo_sigaa, uniqueness: { scope: :semestre, message: "já existe neste semestre" }

  private

  def set_ano_from_semestre
    if self.semestre.present?
      self.ano = self.semestre.split('/').last.to_i
    end
  end
end
```

**Banco de Dados**: Índice único composto
```sql
CREATE UNIQUE INDEX index_turmas_on_codigo_sigaa_and_semestre 
  ON turmas(codigo_sigaa, semestre);
```

---

### Modelo: Student
**Arquivo**: `/backend/app/models/student.rb`

```ruby
class Student < ApplicationRecord
  belongs_to :turma, optional: true 

  validates :matricula, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  
  # Validar que o aluno não está em outra turma com o mesmo codigo_sigaa no mesmo semestre
  validate :unique_turma_per_semester, if: proc { turma.present? }

  private

  def unique_turma_per_semester
    # Verificar se existe alguma outra turma com o mesmo codigo_sigaa e semestre para este aluno
    turma_duplicada = Student
      .joins(:turma)
      .where(matricula: matricula)
      .where.not(id: id) # Excluir o próprio registro (em caso de update)
      .where(turmas: { codigo_sigaa: turma.codigo_sigaa, semestre: turma.semestre })
      .exists?

    if turma_duplicada
      errors.add(:turma, "O aluno já está matriculado em outra turma com o mesmo código SIGAA neste semestre")
    end
  end
end
```

---

## Comportamento na Importação CSV

**Arquivo**: `/backend/app/controllers/admin/importar_controller.rb`

### Características da Importação

1. **Tratamento de Encoding** (✅ Novo):
   - Suporta UTF-8 e ISO-8859-1 (Latin1)
   - Tenta UTF-8 primeiro, fallback para Latin1 se necessário
   - Mensagens de erro descritivas para problemas de encoding

```ruby
# Tentar UTF-8 primeiro, se falhar, tenta ISO-8859-1
begin
  csv_data = csv_data.force_encoding('UTF-8').encode('UTF-8')
rescue Encoding::InvalidByteSequenceError
  csv_data = csv_data.force_encoding('ISO-8859-1').encode('UTF-8')
end
```

2. **Find or Create Turma**:
```ruby
turma_existe = Turma.exists?(codigo_sigaa: codigo_sigaa, semestre: semestre)
turma = Turma.find_or_create_by(codigo_sigaa: codigo_sigaa, semestre: semestre) do |t|
  t.nome = nome_turma
  t.disciplina = disciplina || 'Não informada'
  # O ano é extraído automaticamente do semestre por set_ano_from_semestre
end

unless turma_existe
  if turma.save
    turmas_criadas += 1
  else
    erros << "Turma #{codigo_sigaa} (#{semestre}): #{turma.errors.full_messages.join(', ')}"
    turma = nil
  end
end
```

**Comportamento**:
- Se turma com `codigo_sigaa` + `semestre` existe: reutiliza
- Se não existe: cria nova turma
- Se validação falha: adiciona erro ao array `erros`

3. **Find or Create Aluno** (✅ Melhorado):
```ruby
aluno_existe = Student.exists?(matricula: matricula_aluno)
student = Student.find_or_create_by(matricula: matricula_aluno) do |s|
  s.name = nome_aluno
  s.email = email_aluno
  s.turma_id = turma.id
end

# Se o aluno foi encontrado mas não tem a turma correta, atualizar
if aluno_existe && student.turma_id != turma.id
  student.turma_id = turma.id
end

# Salvar o aluno se for novo ou se houve mudanças
if !aluno_existe || (aluno_existe && student.turma_id != turma.id)
  if student.save
    alunos_criados += 1 unless aluno_existe
  else
    erros << "Matrícula #{matricula_aluno} (#{nome_aluno}): #{student.errors.full_messages.join(', ')}"
  end
end
```

**Comportamento**:
- Se aluno não existe: cria e associa à turma
- Se aluno existe e está em turma diferente: tenta atualizar
  - Se for mesmo código mas semestre diferente: ✅ sucesso
  - Se for mesmo código e semestre: ❌ erro de validação
- Todos os erros são capturados e reportados

---

## Formato CSV para Importação

**Arquivo esperado**: CSV com encoding UTF-8 ou Latin1, separador por vírgula

**Colunas obrigatórias**:
```
codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
```

**Exemplo**:
```csv
codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100001,João Silva,joao@unb.br
CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100002,Maria Santos,maria@unb.br
CIC0004,Turma A,Algoritmos e Programação,1º/2025,202100001,João Silva,joao@unb.br
CIC0005,Turma 02,Estrutura de Dados,2º/2024,202100001,João Silva,joao@unb.br
```

**Nota sobre o campo `semestre`**: 
- Formato esperado: "Nº/AAAA" (ex: "1º/2024", "2º/2024")
- O campo `ano` é extraído automaticamente do `semestre` (ex: "2º/2024" → ano=2024)

**Nota sobre encoding** (✅ Novo):
- Recomenda-se UTF-8
- Suporta Latin1 (ISO-8859-1) automaticamente
- Se salvar no Excel, escolha "CSV UTF-8 (.csv)" ou "CSV ANSI (.csv)"

---

## Resposta da API de Importação

### Sucesso
```json
{
  "message": "Importação concluída! Turmas criadas: 2, Alunos criados: 5.",
  "turmas_criadas": 2,
  "alunos_criados": 5,
  "erros": []
}
```

### Com Erros
```json
{
  "message": "Importação concluída! Turmas criadas: 1, Alunos criados: 2. Erros: Matrícula 20240003: Email pode estar vinculado a outra turma",
  "turmas_criadas": 1,
  "alunos_criados": 2,
  "erros": [
    "Matrícula 20240003 (Pedro Lima): Email pode estar vinculado a outra turma no mesmo semestre",
    "Turma CIC103 (2º/2024): Email pode estar vinculado a outra turma"
  ]
}
```

### Erro de Encoding (✅ Novo)
```json
{
  "message": "Erro de encoding no arquivo CSV: Invalid byte sequence in UTF-8. Certifique-se de que o arquivo está em UTF-8 ou Latin1."
}
```

---

## Testes

### Teste 1: Mesma turma em semestres diferentes
```bash
curl -X POST http://localhost:3001/admin/importar \
  -F "csvFile=@teste_semestres.csv"

# Conteúdo do arquivo:
# codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
# CIC0004,Turma A,Algoritmos,1º/2024,202100001,João Silva,joao@unb.br
# CIC0004,Turma A,Algoritmos,2º/2024,202100001,João Silva,joao@unb.br

# Resultado esperado: 2 turmas criadas, aluno associado a ambas
# "turmas_criadas": 2, "alunos_criados": 1
```

### Teste 2: Tentativa de matricular aluno em mesma turma (deve falhar)
```bash
# Arquivo CSV com mesmo aluno na mesma turma duas vezes
# CIC0004,Turma A,Algoritmos,2º/2024,202100001,João Silva,joao@unb.br
# CIC0004,Turma A,Algoritmos,2º/2024,202100001,João Silva,joao2@unb.br

# Resultado esperado: 0 turmas criadas (já existe), erro na segunda linha
# "turmas_criadas": 0, "alunos_criados": 0 ou 1, com erro reportado
```

### Teste 3: Aluno em turmas diferentes (mesmo código, semestres diferentes)
```bash
# Arquivo CSV com aluno em mesma turma em semestres diferentes
# CIC0004,Turma A,Algoritmos,1º/2024,202100001,João Silva,joao@unb.br
# CIC0004,Turma A,Algoritmos,2º/2024,202100001,João Silva,joao@unb.br

# Resultado esperado: 2 turmas criadas, aluno associado a ambas (sucesso!)
# "turmas_criadas": 2, "alunos_criados": 1
```

### Teste 4: Arquivo com encoding diferente (✅ Novo)
```bash
# Excel Windows-1252, LibreOffice Latin1, etc.
curl -X POST http://localhost:3001/admin/importar \
  -F "csvFile=@teste_latin1.csv"

# Resultado esperado: importação bem-sucedida, encoding automaticamente detectado
```

---

## Changelog

### v1.1 (Atualizações Recentes)
- ✅ Adicionado suporte para múltiplos encodings (UTF-8 e Latin1)
- ✅ Melhorado tratamento de erros na importação CSV
- ✅ Implementado `dependent: :destroy` em Turma -> Student
- ✅ Corrigida sintaxe de validação custom (usando `proc`)
- ✅ Salvamento explícito de turmas e alunos com validação
- ✅ Mensagens de erro mais descritivas

### v1.0 (Inicial)
- ✅ Validação de unicidade de turmas por `codigo_sigaa + semestre`
- ✅ Validação de matrícula única por semestre
- ✅ Importação CSV completa
- ✅ Índice único composto no banco de dados
