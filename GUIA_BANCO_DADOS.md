# Guia do Banco de Dados CAMAAR

## Visão Geral
O CAMAAR é um sistema para avaliação de atividades acadêmicas remotas do CIC. O banco de dados SQLite armazena informações sobre disciplinas, turmas, docentes e discentes.

## Estrutura do Banco

### Tabelas Principais

#### 1. disciplinas
Armazena as disciplinas oferecidas
```sql
CREATE TABLE disciplinas (
    code TEXT PRIMARY KEY,    -- Código da disciplina (ex: CIC0097)
    name TEXT NOT NULL        -- Nome da disciplina (ex: BANCOS DE DADOS)
);
```

#### 2. turmas
Representa as turmas de cada disciplina por semestre
```sql
CREATE TABLE turmas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    disciplina_code TEXT NOT NULL,    -- FK para disciplinas
    class_code TEXT NOT NULL,         -- Código da turma (ex: TA)
    semester TEXT NOT NULL,           -- Semestre (ex: 2021.2)
    time TEXT                         -- Horário (ex: 35T45)
);
```

#### 3. docentes
Informações dos professores
```sql
CREATE TABLE docentes (
    usuario TEXT PRIMARY KEY,         -- CPF ou ID único
    nome TEXT NOT NULL,
    departamento TEXT,
    formacao TEXT,                    -- DOUTORADO, MESTRADO, etc.
    email TEXT UNIQUE NOT NULL,
    ocupacao TEXT DEFAULT 'docente'
);
```

#### 4. discentes
Informações dos estudantes
```sql
CREATE TABLE discentes (
    matricula TEXT PRIMARY KEY,      -- Matrícula do aluno
    nome TEXT NOT NULL,
    curso TEXT NOT NULL,
    usuario TEXT UNIQUE NOT NULL,     -- Usuário de login
    formacao TEXT DEFAULT 'graduando',
    ocupacao TEXT DEFAULT 'dicente',
    email TEXT UNIQUE NOT NULL
);
```

#### 5. turma_docente
Relacionamento N:M entre turmas e docentes
```sql
CREATE TABLE turma_docente (
    turma_id INTEGER,
    docente_usuario TEXT,
    PRIMARY KEY (turma_id, docente_usuario)
);
```

#### 6. matriculas
Relacionamento N:M entre turmas e discentes
```sql
CREATE TABLE matriculas (
    turma_id INTEGER,
    discente_matricula TEXT,
    PRIMARY KEY (turma_id, discente_matricula)
);
```

## Consultas Essenciais

### 1. Listar todas as disciplinas
```sql
SELECT code, name FROM disciplinas;
```

### 2. Buscar turmas de uma disciplina específica
```sql
SELECT t.*, d.name as disciplina_nome 
FROM turmas t
JOIN disciplinas d ON t.disciplina_code = d.code
WHERE d.code = 'CIC0097';
```

### 3. Listar alunos de uma turma
```sql
SELECT ds.matricula, ds.nome, ds.curso, ds.email
FROM discentes ds
JOIN matriculas m ON ds.matricula = m.discente_matricula
JOIN turmas t ON m.turma_id = t.id
WHERE t.disciplina_code = 'CIC0097' 
  AND t.class_code = 'TA' 
  AND t.semester = '2021.2';
```

### 4. Buscar professor de uma turma
```sql
SELECT doc.nome, doc.email, doc.departamento
FROM docentes doc
JOIN turma_docente td ON doc.usuario = td.docente_usuario
JOIN turmas t ON td.turma_id = t.id
WHERE t.disciplina_code = 'CIC0097' 
  AND t.class_code = 'TA' 
  AND t.semester = '2021.2';
```

### 5. Contar alunos por curso em uma disciplina
```sql
SELECT ds.curso, COUNT(*) as total_alunos
FROM discentes ds
JOIN matriculas m ON ds.matricula = m.discente_matricula
JOIN turmas t ON m.turma_id = t.id
WHERE t.disciplina_code = 'CIC0097'
GROUP BY ds.curso
ORDER BY total_alunos DESC;
```

### 6. Buscar todas as turmas de um professor
```sql
SELECT d.name as disciplina, t.class_code, t.semester, t.time
FROM turmas t
JOIN disciplinas d ON t.disciplina_code = d.code
JOIN turma_docente td ON t.id = td.turma_id
JOIN docentes doc ON td.docente_usuario = doc.usuario
WHERE doc.email = 'mholanda@unb.br';
```

## Operações de Inserção

### 1. Adicionar nova disciplina
```sql
INSERT INTO disciplinas (code, name) 
VALUES ('CIC0123', 'NOVA DISCIPLINA');
```

### 2. Criar nova turma
```sql
INSERT INTO turmas (disciplina_code, class_code, semester, time) 
VALUES ('CIC0123', 'TB', '2024.1', '24M34');
```

### 3. Matricular aluno em turma
```sql
-- Primeiro, obter o ID da turma
SELECT id FROM turmas 
WHERE disciplina_code = 'CIC0123' 
  AND class_code = 'TB' 
  AND semester = '2024.1';

-- Depois, inserir a matrícula (assumindo turma_id = 4)
INSERT INTO matriculas (turma_id, discente_matricula) 
VALUES (4, '190084006');
```

### 4. Associar professor à turma
```sql
INSERT INTO turma_docente (turma_id, docente_usuario) 
VALUES (4, '83807519491');
```

## Operações de Atualização

### 1. Atualizar email de aluno
```sql
UPDATE discentes 
SET email = 'novo.email@aluno.unb.br' 
WHERE matricula = '190084006';
```

### 2. Alterar horário de turma
```sql
UPDATE turmas 
SET time = '46T23' 
WHERE disciplina_code = 'CIC0097' 
  AND class_code = 'TA' 
  AND semester = '2021.2';
```

### 3. Atualizar formação do docente
```sql
UPDATE docentes 
SET formacao = 'PÓS-DOUTORADO' 
WHERE usuario = '83807519491';
```

## Integração com a Aplicação

### Para Login de Usuários
```sql
-- Verificar se é docente
SELECT usuario, nome, email, 'docente' as tipo 
FROM docentes 
WHERE email = ? AND usuario = ?;

-- Verificar se é discente
SELECT usuario, nome, email, 'discente' as tipo 
FROM discentes 
WHERE email = ? AND usuario = ?;
```

### Para Dashboard do Professor
```sql
-- Turmas do professor logado
SELECT d.name, t.class_code, t.semester, 
       COUNT(m.discente_matricula) as total_alunos
FROM turmas t
JOIN disciplinas d ON t.disciplina_code = d.code
JOIN turma_docente td ON t.id = td.turma_id
LEFT JOIN matriculas m ON t.id = m.turma_id
WHERE td.docente_usuario = ?
GROUP BY t.id, d.name, t.class_code, t.semester;
```

### Para Dashboard do Aluno
```sql
-- Disciplinas do aluno logado
SELECT d.name, t.class_code, t.semester, doc.nome as professor
FROM turmas t
JOIN disciplinas d ON t.disciplina_code = d.code
JOIN matriculas m ON t.id = m.turma_id
JOIN turma_docente td ON t.id = td.turma_id
JOIN docentes doc ON td.docente_usuario = doc.usuario
WHERE m.discente_matricula = ?;
```

## Configuração Inicial

1. **Instalar SQLite** (se não estiver instalado)
2. **Executar setup**:
   ```bash
   cd db-files
   bash setup_database.sh
   ```
3. **Conectar na aplicação**:
   ```javascript
   // Node.js exemplo
   const sqlite3 = require('sqlite3').verbose();
   const db = new sqlite3.Database('./db-files/camaar.db');
   ```

## Backup e Manutenção

### Backup do banco
```bash
cp camaar.db camaar_backup_$(date +%Y%m%d).db
```

### Verificar integridade
```sql
PRAGMA integrity_check;
```

### Estatísticas das tabelas
```sql
SELECT name, 
       (SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name=m.name) as count
FROM sqlite_master m WHERE type='table';
```