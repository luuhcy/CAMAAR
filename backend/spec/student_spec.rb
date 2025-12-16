require 'rails_helper'

# Testes do model Student
RSpec.describe Student, type: :model do
  let(:turma) { Turma.create!(codigo_sigaa: 'TST001', nome: 'Turma Teste', disciplina: 'Teste', semestre: '1/2025', ano: 2025) }
  
  # Turma é opcional
  it { should belong_to(:turma).optional }

  # Campos obrigatórios
  it { should validate_presence_of(:matricula) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      student = Student.new(name: 'João Silva', email: 'joao@example.com', matricula: '200012345', turma: turma)
      expect(student).to be_valid
    end
    
    it 'is invalid without a name' do
      student = Student.new(name: nil, email: 'test@example.com', matricula: '123', turma: turma)
      expect(student).to_not be_valid
    end
    
    it 'is invalid without a matricula' do
      student = Student.new(name: 'Test', email: 'test@example.com', matricula: nil, turma: turma)
      expect(student).to_not be_valid
    end
    
    it 'is invalid without an email' do
      student = Student.new(name: 'Test', email: nil, matricula: '123', turma: turma)
      expect(student).to_not be_valid
    end
    
    it 'is invalid with a duplicate matricula' do
      Student.create!(name: 'Student 1', email: 'student1@example.com', matricula: '200011111', turma: turma)
      student2 = Student.new(name: 'Student 2', email: 'student2@example.com', matricula: '200011111', turma: turma)
      expect(student2).to_not be_valid
    end
    
    it 'is invalid with a duplicate email' do
      Student.create!(name: 'Student 1', email: 'same@example.com', matricula: '200022222', turma: turma)
      student2 = Student.new(name: 'Student 2', email: 'same@example.com', matricula: '200033333', turma: turma)
      expect(student2).to_not be_valid
    end
  end
  
  describe 'associations' do
    it 'can exist without a turma' do
      student = Student.new(name: 'Test', email: 'test@example.com', matricula: '200099999', turma: nil)
      expect(student).to be_valid
    end
    
    it 'belongs to a turma when assigned' do
      student = Student.create!(name: 'Test', email: 'test2@example.com', matricula: '200088888', turma: turma)
      expect(student.turma).to eq(turma)
    end
    
    it 'can have multiple students in the same turma' do
      student1 = Student.create!(name: 'Student 1', email: 'student1a@example.com', matricula: '200077777', turma: turma)
      student2 = Student.create!(name: 'Student 2', email: 'student2a@example.com', matricula: '200066666', turma: turma)
      
      expect(turma.students).to include(student1, student2)
    end
  end
end
