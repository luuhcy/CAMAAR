-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "matricula" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "tipo" TEXT NOT NULL DEFAULT 'user'
);

-- CreateTable
CREATE TABLE "Template" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "dataCriacao" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "idUsuario" INTEGER NOT NULL,
    CONSTRAINT "Template_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Questao" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "texto" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "obrigatoria" BOOLEAN NOT NULL DEFAULT true,
    "ordem" INTEGER NOT NULL,
    "opcoes" TEXT,
    "templateId" INTEGER NOT NULL,
    CONSTRAINT "Questao_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "Template" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Turma" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "codigoSigaa" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "disciplina" TEXT NOT NULL,
    "semestre" TEXT NOT NULL,
    "ano" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "Student" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "matricula" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "turmaId" INTEGER NOT NULL,
    CONSTRAINT "Student_turmaId_fkey" FOREIGN KEY ("turmaId") REFERENCES "Turma" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Formulario" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "titulo" TEXT NOT NULL,
    "dataInicio" DATETIME NOT NULL,
    "dataTermino" DATETIME NOT NULL,
    "templateId" INTEGER NOT NULL,
    "turmaId" INTEGER NOT NULL,
    CONSTRAINT "Formulario_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "Template" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Formulario_turmaId_fkey" FOREIGN KEY ("turmaId") REFERENCES "Turma" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Resposta" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "dataResposta" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL,
    "usuarioId" INTEGER NOT NULL,
    "formularioId" INTEGER NOT NULL,
    CONSTRAINT "Resposta_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Resposta_formularioId_fkey" FOREIGN KEY ("formularioId") REFERENCES "Formulario" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_matricula_key" ON "User"("matricula");

-- CreateIndex
CREATE UNIQUE INDEX "Turma_disciplina_semestre_ano_nome_key" ON "Turma"("disciplina", "semestre", "ano", "nome");

-- CreateIndex
CREATE UNIQUE INDEX "Student_matricula_key" ON "Student"("matricula");
