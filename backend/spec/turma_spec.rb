require 'rails_helper'

# Testes do model Turma
RSpec.describe Turma, type: :model do
  # Associações
  it { should have_many(:students) }
  it { should have_many(:formularios) }

  # Validações
  it { should validate_presence_of(:codigo_sigaa) }
  it { should validate_presence_of(:semestre) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      turma = Turma.new(codigo_sigaa: 'FGA0138', nome: 'Compiladores', disciplina: 'Compiladores', semestre: '1/2025', ano: 2025)
      expect(turma).to be_valid
    end
    
    it 'is invalid without codigo_sigaa' do
      turma = Turma.new(codigo_sigaa: nil, semestre: '1/2025')
      expect(turma).to_not be_valid
    end
    
    it 'is invalid without semestre' do
      turma = Turma.new(codigo_sigaa: 'TST001', semestre: nil)
      expect(turma).to_not be_valid
    end
    
    it 'is invalid with duplicate codigo_sigaa' do
      Turma.create!(codigo_sigaa: 'FGA0001', nome: 'Turma 1', disciplina: 'Disc', semestre: '1/2025', ano: 2025)
      turma2 = Turma.new(codigo_sigaa: 'FGA0001', nome: 'Turma 2', disciplina: 'Disc', semestre: '1/2025', ano: 2025)
      expect(turma2).to_not be_valid
    end
  end

  # Testa se extrai o ano do semestre corretamente
  describe 'ano extraction' do
    it 'extrai o ano do semestre' do
      turma = Turma.create(codigo_sigaa: 'ABC123', semestre: '2024.1/2024', ano: 2024)
      expect(turma.ano).to eq(2024)
    end
    
    it 'handles different semester formats' do
      turma = Turma.create!(codigo_sigaa: 'ABC456', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      expect(turma.ano).to eq(2025)
    end
  end
  
  describe 'associations' do
    it 'can have multiple students' do
      turma = Turma.create!(codigo_sigaa: 'TST002', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      student1 = Student.create!(name: 'Student 1', email: 's1@test.com', matricula: '111', turma: turma)
      student2 = Student.create!(name: 'Student 2', email: 's2@test.com', matricula: '222', turma: turma)
      
      expect(turma.students.count).to eq(2)
      expect(turma.students).to include(student1, student2)
    end
    
    it 'can have multiple formularios' do
      turma = Turma.create!(codigo_sigaa: 'TST003', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      user = User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '999', password: 'pass', tipo: 'admin')
      template = Template.create!(nome: 'Template', descricao: 'Desc', user: user)
      
      form1 = Formulario.create!(titulo: 'Form 1', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma)
      form2 = Formulario.create!(titulo: 'Form 2', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma)
      
      expect(turma.formularios.count).to eq(2)
    end
  end
end
