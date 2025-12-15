# backend/db/seeds.rb

#Popular o banco de dados com dados iniciais para desenvolvimento e testes, pode ser limpo mantendo o admin, pois há csv e json com dados de alunos.

# Limpar dados na ordem correta (respeitar foreign keys)
Formulario.destroy_all
Questao.destroy_all
Template.destroy_all
Student.destroy_all
Turma.destroy_all
User.destroy_all

User.create!(
  nome: "Admin",
  email: "admin@aluno.unb.br",
  matricula: "000000",
  password: "12345678",
  tipo: "admin"
)
puts "Usuário Admin criado com sucesso."

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

# ALUNOS

puts "Criando alunos..."

turma_fga = Turma.find_by(codigo_sigaa: "FGA0138")

Student.create!(
  name: "João Silva",
  matricula: "200012345",
  email: "joao.silva@aluno.unb.br",
  turma_id: turma_fga.id
)

User.create!(
  nome: "João Silva",
  email: "joao.silva@aluno.unb.br",
  matricula: "200012345",
  password: "12345678",
  tipo: "estudante"
)

puts "✅ Aluno criado com sucesso!"

#TEMPLATES DE AVALIAÇÃO

puts "Criando templates de avaliação..."

admin_user = User.find_by(tipo: "admin")

template1 = Template.create!(
  nome: "Avaliação de Desempenho Docente",
  descricao: "Template padrão para avaliação do desempenho do professor ao final do semestre",
  user_id: admin_user.id
)

Questao.create!(
  texto: "Como você avalia a qualidade do ensino deste professor?",
  tipo: "radio",
  obrigatoria: true,
  ordem: 1,
  opcoes: ["Excelente", "Bom", "Regular", "Ruim"].to_json,
  template_id: template1.id
)

Questao.create!(
  texto: "O professor demonstra domínio sobre o conteúdo?",
  tipo: "radio",
  obrigatoria: true,
  ordem: 2,
  opcoes: ["Sim", "Parcialmente", "Não"].to_json,
  template_id: template1.id
)

Questao.create!(
  texto: "Deixe sugestões para melhorias:",
  tipo: "texto",
  obrigatoria: false,
  ordem: 3,
  opcoes: [].to_json,
  template_id: template1.id
)

template2 = Template.create!(
  nome: "Avaliação de Projeto/Extensão",
  descricao: "Template para avaliar projetos de extensão e relevância acadêmica",
  user_id: admin_user.id
)

Questao.create!(
  texto: "Qual o nível de relevância deste projeto para a comunidade?",
  tipo: "radio",
  obrigatoria: true,
  ordem: 1,
  opcoes: ["Alta", "Média", "Baixa"].to_json,
  template_id: template2.id
)

Questao.create!(
  texto: "A equipe apresentou eficiência na execução?",
  tipo: "radio",
  obrigatoria: true,
  ordem: 2,
  opcoes: ["Muito Eficiente", "Eficiente", "Pouco Eficiente", "Ineficiente"].to_json,
  template_id: template2.id
)

Questao.create!(
  texto: "Quais foram os principais aprendizados?",
  tipo: "texto",
  obrigatoria: true,
  ordem: 3,
  opcoes: [].to_json,
  template_id: template2.id
)

puts "✅ Templates de avaliação criados com sucesso!"

# FORMULÁRIOS - Vinculando Templates às Turmas

puts "Criando formulários..."

turma_cic = Turma.find_by(codigo_sigaa: "CIC0004")
turma_mat = Turma.find_by(codigo_sigaa: "MAT0025")
turma_fga = Turma.find_by(codigo_sigaa: "FGA0138")

# Formulário 1: Avaliação Docente para CIC0004
Formulario.create!(
  titulo: "Avaliação do Professor - Algoritmos e Programação",
  data_inicio: DateTime.new(2025, 12, 1, 0, 0, 0),
  data_termino: DateTime.new(2025, 12, 31, 23, 59, 59),
  template_id: template1.id,
  turma_id: turma_cic.id
)

# Formulário 2: Avaliação Docente para MAT0025
Formulario.create!(
  titulo: "Avaliação do Professor - Cálculo 1",
  data_inicio: DateTime.new(2025, 12, 1, 0, 0, 0),
  data_termino: DateTime.new(2025, 12, 31, 23, 59, 59),
  template_id: template1.id,
  turma_id: turma_mat.id
)

# Formulário 4: Avaliação Docente para FGA0138 (turma também tem avaliação do professor)
Formulario.create!(
  titulo: "Avaliação do Professor - Métodos de Design",
  data_inicio: DateTime.new(2025, 12, 5, 0, 0, 0),
  data_termino: DateTime.new(2025, 12, 25, 23, 59, 59),
  template_id: template1.id,
  turma_id: turma_fga.id
)

puts "✅ Formulários criados e vinculados às turmas com sucesso!"