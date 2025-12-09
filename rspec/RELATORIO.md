# Relatório dos Testes

## O que foi testado

Fiz testes pra todos os models e controllers principais do sistema. No total deu 28 testes e todos passaram.

## Models

**User** - Testa se o usuário tem templates e se a senha tá sendo criptografada direito

**Template** - Verifica se tá ligado com user e formulários

**Questao** - Checa se pertence a um template

**Turma** - Testa as validações de código e semestre, e se o ano tá sendo extraído certo do semestre

**Student** - Valida os campos obrigatórios (matrícula, nome, email)

**Formulario** - Verifica ligação com template e turma

**Respostum** - Testa associação com user e formulário

## Controllers

Testei as rotas principais de cada controller:
- Listar todos (GET)
- Criar novo (POST)

Pro SessionsController testei o login com senha certa e errada.

## Resultado

28 testes rodaram em 0.37 segundos, todos passaram.

## Como rodar

Criei um script `run-tests.sh` que roda as migrations e depois os testes.
