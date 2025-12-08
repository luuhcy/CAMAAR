# backend/db/seeds.rb

User.find_by(email: "admin@aluno.unb.br")&.destroy

User.create!(
  nome: "Admin",
  email: "admin@aluno.unb.br",
  matricula: "000000",
  password: "12345678",
  tipo: "admin"
)
puts "Usuário Admin criado com sucesso."

Turma.destroy_all

puts "Criando turmas..."

def create_turma(codigo_sigaa, nome, disciplina, semestre)
  ano = semestre.split('/').last.to_i 
  
  Turma.create!(
    codigo_sigaa: codigo_sigaa,
    nome: nome,
    disciplina: disciplina,
    semestre: semestre,
    ano: ano
  )
end

create_turma("CIC0004", "Turma A", "Algoritmos e Programação", "2º/2024")
create_turma("MAT0025", "Turma C", "Cálculo 1", "2º/2024")
create_turma("FGA0138", "Turma A", "Métodos de Design", "1º/2025")

puts "✅ Turmas cadastradas com sucesso!"