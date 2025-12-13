# Testes RSpec - CAMAAR

## Testes Criados

### 1. Turma (`turma_spec.rb`)
- ✅ Cria turma válida
- ❌ Não aceita turma sem código
- ✅ Permite mesmo código em semestres diferentes  
- ❌ Não permite mesmo código no mesmo semestre

### 2. Student (`student_spec.rb`)
- ✅ Cria aluno válido
- ❌ Não aceita aluno sem matrícula
- ✅ Permite mesmo aluno em semestres diferentes
- ❌ Não permite mesmo aluno na mesma turma

### 3. Importação CSV (`importar_controller_spec.rb`)
- ✅ Importa CSV válido
- ❌ Retorna erro sem arquivo
- ✅ Permite mesmo aluno em semestres diferentes

### 4. Turmas Controller (`turmas_controller_spec.rb`)
- ✅ Lista turmas
- ✅ Mostra turma
- ✅ Cria turma
- ❌ Não cria turma inválida

### 5. User (`user_spec.rb`)
- ✅ Cria usuário válido
- ✅ Autentica senha correta
- ❌ Rejeita senha errada

## Como rodar

**Primeira vez (instalar gems):**
```bash
cd rspec/
bash instalar.sh
```

**Rodar testes:**
```bash
bash run-tests-simple.sh
```