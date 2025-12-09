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
- **Validação em Nível de Modelo**: Custom validation `unique_turma_per_semester`

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
  # ... relacionamentos ...
  
  validates :codigo_sigaa, uniqueness: { scope: :semestre, message: "já existe neste semestre" }
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
  validates :turma, unique_turma_per_semester: true, if: :turma.present?
  
  private
  
  def unique_turma_per_semester
    turma_duplicada = Student
      .joins(:turma)
      .where(matricula: matricula)
      .where.not(id: id)
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

### Find or Create Turma
```ruby
turma = Turma.find_or_create_by(codigo_sigaa: codigo_sigaa, semestre: semestre) do |t|
  # ... inicializar novos campos ...
end
```

**Comportamento**:
- Se turma com `codigo_sigaa` + `semestre` existe: reutiliza
- Se não existe: cria nova turma
- Se validação falha: adiciona erro ao array `erros`

### Find or Create Aluno
```ruby
student = Student.find_or_create_by(matricula: matricula_aluno) do |s|
  s.turma_id = turma.id
end

# Se aluno existe mas está em turma diferente
if !student.newly_created? && student.turma_id != turma.id
  student.turma_id = turma.id
  student.save  # Dispara validação unique_turma_per_semester
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

**Arquivo esperado**: CSV com encoding UTF-8, separador por vírgula

**Colunas obrigatórias**:
```
codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
```

**Exemplo**:
```csv
codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100001,João Silva,joao@unb.br
CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100002,Maria Santos,maria@unb.br
CIC0004,Turma A,Algoritmos e Programação,1º/2024,202100001,João Silva,joao@unb.br
CIC0005,Estruturas de Dados,Estruturas,2º/2024,202100001,João Silva,joao@unb.br
```

**Nota sobre o campo `semestre`**: 
- Formato esperado: "Nº/AAAA" (ex: "1º/2024", "2º/2024")
- O campo `ano` é extraído automaticamente do `semestre` (ex: "2º/2024" → ano=2024)

**Resultado esperado**:
- ✅ Turma CS101 (1º/2024) criada com 2 alunos
- ✅ Turma CS101 (2º/2024) criada com 1 aluno (João rematriculado em semestre diferente)
- ✅ Turma CS102 (1º/2024) criada com 1 aluno (João em código diferente)
- ✅ Alunos no sistema: João, Maria, Maria (se não existisse)

---

## Resposta da API de Importação

```json
{
  "message": "Importação concluída! Turmas criadas: 3, Alunos criados: 2.",
  "turmas_criadas": 3,
  "alunos_criados": 2,
  "erros": [
    "Matrícula 20240003 (Pedro Lima): Email já existe no sistema",
    "Turma CS103 (2º/2024): Email pode estar vinculado a outra turma no mesmo semestre"
  ]
}
```

---

## Testes

Para validar o comportamento das regras:

### Teste 1: Mesma turma em semestres diferentes
```bash
curl -X POST http://localhost:3001/admin/importar \
  -F "csvFile=@test_mesmo_codigo_semestres.csv"

# Conteúdo do arquivo:
# codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
# CIC0004,Turma A,Algoritmos e Programação,1º/2024,202100001,João Silva,joao@unb.br
# CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100001,João Silva,joao@unb.br

# Resultado: 2 turmas criadas (CIC0004/1º/2024 e CIC0004/2º/2024)
```

### Teste 2: Tentativa de matricular aluno em mesma turma (deve falhar)
```bash
# Arquivo CSV com mesmo aluno na mesma turma duas vezes
# CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100001,João Silva,joao@unb.br
# CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100001,João Silva,joao@unb.br

# Resultado: 1 turma criada, 1 aluno criado, 1 erro reportado
```

### Teste 3: Aluno em turmas diferentes (mesmo código, semestres diferentes)
```bash
# Arquivo CSV com aluno em mesma turma em semestres diferentes
# CIC0004,Turma A,Algoritmos e Programação,1º/2024,202100001,João Silva,joao@unb.br
# CIC0004,Turma A,Algoritmos e Programação,2º/2024,202100001,João Silva,joao@unb.br

# Resultado: 2 turmas criadas, aluno associado a ambas (sucesso!)
```
