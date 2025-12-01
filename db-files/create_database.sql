-- Criação do banco de dados CAMAAR
-- Sistema para avaliação de atividades acadêmicas remotas do CIC

-- Tabela de disciplinas
CREATE TABLE disciplinas (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

-- Tabela de turmas
CREATE TABLE turmas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    disciplina_code TEXT NOT NULL,
    class_code TEXT NOT NULL,
    semester TEXT NOT NULL,
    time TEXT,
    FOREIGN KEY (disciplina_code) REFERENCES disciplinas(code),
    UNIQUE(disciplina_code, class_code, semester)
);

-- Tabela de docentes
CREATE TABLE docentes (
    usuario TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    departamento TEXT,
    formacao TEXT,
    email TEXT UNIQUE NOT NULL,
    ocupacao TEXT DEFAULT 'docente'
);

-- Tabela de discentes
CREATE TABLE discentes (
    matricula TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    curso TEXT NOT NULL,
    usuario TEXT UNIQUE NOT NULL,
    formacao TEXT DEFAULT 'graduando',
    ocupacao TEXT DEFAULT 'dicente',
    email TEXT UNIQUE NOT NULL
);

-- Tabela de relacionamento turma-docente
CREATE TABLE turma_docente (
    turma_id INTEGER,
    docente_usuario TEXT,
    PRIMARY KEY (turma_id, docente_usuario),
    FOREIGN KEY (turma_id) REFERENCES turmas(id),
    FOREIGN KEY (docente_usuario) REFERENCES docentes(usuario)
);

-- Tabela de relacionamento turma-discente (matrículas)
CREATE TABLE matriculas (
    turma_id INTEGER,
    discente_matricula TEXT,
    PRIMARY KEY (turma_id, discente_matricula),
    FOREIGN KEY (turma_id) REFERENCES turmas(id),
    FOREIGN KEY (discente_matricula) REFERENCES discentes(matricula)
);

-- Índices para melhor performance
CREATE INDEX idx_turmas_disciplina ON turmas(disciplina_code);
CREATE INDEX idx_turmas_semester ON turmas(semester);
CREATE INDEX idx_discentes_curso ON discentes(curso);
CREATE INDEX idx_matriculas_turma ON matriculas(turma_id);
CREATE INDEX idx_matriculas_discente ON matriculas(discente_matricula);