-- Criação do banco de dados CAMAAR v2
-- Baseado no diagrama ER fornecido

-- Tabela de usuários (unifica docentes e discentes)
CREATE TABLE usuario (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    senha TEXT,
    email TEXT UNIQUE NOT NULL,
    matricula TEXT UNIQUE,
    nome TEXT NOT NULL,
    tipo_usuario TEXT NOT NULL CHECK (tipo_usuario IN ('docente', 'discente')),
    admin BOOLEAN DEFAULT 0,
    user TEXT UNIQUE NOT NULL
);

-- Tabela de turmas
CREATE TABLE turma (
    id_turma INTEGER PRIMARY KEY AUTOINCREMENT,
    cod_sigaa TEXT NOT NULL,
    semestre TEXT NOT NULL,
    disciplina TEXT NOT NULL,
    nome TEXT NOT NULL,
    ano INTEGER NOT NULL
);

-- Relacionamento N:M entre usuário e turma
CREATE TABLE usuario_turma (
    usuario_id INTEGER,
    turma_id INTEGER,
    PRIMARY KEY (usuario_id, turma_id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (turma_id) REFERENCES turma(id_turma)
);

-- Tabela de templates
CREATE TABLE template (
    id_template INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    data DATE NOT NULL,
    id_usuario INTEGER NOT NULL,
    atributo TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

-- Tabela de questões
CREATE TABLE questao (
    id_questao INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo TEXT NOT NULL,
    opcao TEXT,
    template_id INTEGER NOT NULL,
    texto TEXT NOT NULL,
    ordem INTEGER,
    FOREIGN KEY (template_id) REFERENCES template(id_template)
);

-- Tabela de formulários
CREATE TABLE formulario (
    id_formulario INTEGER PRIMARY KEY AUTOINCREMENT,
    id_template INTEGER NOT NULL,
    titulo TEXT NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (id_template) REFERENCES template(id_template)
);

-- Tabela de respostas
CREATE TABLE resposta (
    id_resposta INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    formulario_id INTEGER NOT NULL,
    data DATE NOT NULL,
    status TEXT DEFAULT 'pendente',
    FOREIGN KEY (usuario_id) REFERENCES usuario(id),
    FOREIGN KEY (formulario_id) REFERENCES formulario(id_formulario)
);

-- Índices para performance
CREATE INDEX idx_usuario_tipo ON usuario(tipo_usuario);
CREATE INDEX idx_usuario_email ON usuario(email);
CREATE INDEX idx_turma_disciplina ON turma(disciplina);
CREATE INDEX idx_turma_semestre ON turma(semestre);
CREATE INDEX idx_questao_template ON questao(template_id);
CREATE INDEX idx_resposta_usuario ON resposta(usuario_id);
CREATE INDEX idx_resposta_formulario ON resposta(formulario_id);