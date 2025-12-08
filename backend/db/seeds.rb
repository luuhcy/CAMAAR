# backend/db/seeds.rb

# 1. Cria o Usuário Admin (se não existir)
if User.count == 0
  User.create!(
    nome: "Admin",
    email: "admin@aluno.unb.br",
    matricula: "123456789",
    password: "12345678",
    tipo: "admin"
  )
  puts "✅ Usuário Admin criado."
end

# 2. Limpa turmas antigas para não duplicar se rodar o seed de novo
# (Cuidado: isso apaga as turmas existentes!)
Turma.destroy_all

# 3. Cria Turmas de Exemplo
puts "⏳ Criando turmas..."

Turma.create!(
  codigo_sigaa: "CIC0004",
  nome: "Turma A",
  disciplina: "Algoritmos e Programação",
  semestre: "2º/2024",
  ano: 2024
)

Turma.create!(
  codigo_sigaa: "MAT0025",
  nome: "Turma C",
  disciplina: "Cálculo 1",
  semestre: "2º/2024",
  ano: 2024
)

Turma.create!(
  codigo_sigaa: "FGA0138",
  nome: "Turma A",
  disciplina: "Métodos de Design",
  semestre: "1º/2025",
  ano: 2025
)

puts "✅ Turmas cadastradas com sucesso!"