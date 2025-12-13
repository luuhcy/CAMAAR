require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:turma) { Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '1º/2024') }

  # Testa criação básica
  it 'cria aluno válido' do
    aluno = Student.new(matricula: '20240001', name: 'João', email: 'joao@unb.br', turma: turma)
    expect(aluno).to be_valid
  end

  # Testa campos obrigatórios
  it 'não aceita aluno sem matrícula' do
    aluno = Student.new(name: 'João', email: 'joao@unb.br')
    expect(aluno).not_to be_valid
  end

  # Testa regra principal: mesmo aluno em semestres diferentes
  it 'permite mesmo aluno em semestres diferentes' do
    turma1 = Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '1º/2024')
    turma2 = Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '2º/2024')
    
    aluno1 = Student.create!(matricula: '20240001', name: 'João', email: 'joao@unb.br', turma: turma1)
    aluno1.update!(turma: turma2)
    
    expect(aluno1).to be_valid
  end

  # Testa regra: não pode estar na mesma turma duas vezes
  it 'não permite mesmo aluno na mesma turma' do
    Student.create!(matricula: '20240001', name: 'João', email: 'joao@unb.br', turma: turma)
    aluno2 = Student.new(matricula: '20240001', name: 'João', email: 'joao2@unb.br', turma: turma)
    
    expect(aluno2).not_to be_valid
  end
end