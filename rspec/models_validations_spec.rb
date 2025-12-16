require 'rails_helper'

# Testes adicionais de validações dos models
RSpec.describe 'Models Validations', type: :model do
  describe 'Student validations' do
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    context 'validações básicas (Happy Path)' do
      it 'cria student válido' do
        student = Student.new(name: 'Aluno Teste', email: 'aluno@test.com', matricula: '123456', turma: turma)
        expect(student).to be_valid
      end
    end
    
    context 'validações de erro (Sad Path)' do
      it 'não aceita student sem nome' do
        student = Student.new(email: 'aluno@test.com', matricula: '123456', turma: turma)
        expect(student).not_to be_valid
        expect(student.errors[:name]).to include("can't be blank")
      end
      
      it 'não aceita student sem email' do
        student = Student.new(name: 'Aluno', matricula: '123456', turma: turma)
        expect(student).not_to be_valid
        expect(student.errors[:email]).to include("can't be blank")
      end
      
      it 'não aceita student sem matrícula' do
        student = Student.new(name: 'Aluno', email: 'aluno@test.com', turma: turma)
        expect(student).not_to be_valid
        expect(student.errors[:matricula]).to include("can't be blank")
      end
      
      it 'não permite matrícula duplicada na mesma turma' do
        Student.create!(name: 'Aluno 1', email: 'aluno1@test.com', matricula: '123456', turma: turma)
        student2 = Student.new(name: 'Aluno 2', email: 'aluno2@test.com', matricula: '123456', turma: turma)
        expect(student2).not_to be_valid
      end
    end
  end
  
  describe 'Turma validations' do
    context 'validações básicas (Happy Path)' do
      it 'cria turma válida' do
        turma = Turma.new(codigo_sigaa: 'CIC001', nome: 'Turma Teste', disciplina: 'Disciplina', semestre: '2024.1')
        expect(turma).to be_valid
      end
      
      it 'permite mesmo código em semestres diferentes' do
        Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma 1', disciplina: 'Disciplina', semestre: '2024.1')
        turma2 = Turma.new(codigo_sigaa: 'CIC001', nome: 'Turma 2', disciplina: 'Disciplina', semestre: '2024.2')
        expect(turma2).to be_valid
      end
    end
    
    context 'validações de erro (Sad Path)' do
      it 'não aceita turma sem código' do
        turma = Turma.new(nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1')
        expect(turma).not_to be_valid
        expect(turma.errors[:codigo_sigaa]).to include("can't be blank")
      end
      
      it 'não permite mesmo código no mesmo semestre' do
        Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma 1', disciplina: 'Disciplina', semestre: '2024.1')
        turma2 = Turma.new(codigo_sigaa: 'CIC001', nome: 'Turma 2', disciplina: 'Disciplina', semestre: '2024.1')
        expect(turma2).not_to be_valid
      end
    end
  end
  
  describe 'Questao validations' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    
    context 'validações básicas (Happy Path)' do
      it 'cria questão válida' do
        questao = Questao.new(texto: 'Pergunta teste', tipo: 'texto', template: template)
        expect(questao).to be_valid
      end
    end
    
    context 'validações de erro (Sad Path)' do
      it 'não aceita questão sem texto' do
        questao = Questao.new(tipo: 'texto', template: template)
        expect(questao).not_to be_valid
        expect(questao.errors[:texto]).to include("can't be blank")
      end
      
      it 'não aceita questão sem template' do
        questao = Questao.new(texto: 'Pergunta', tipo: 'texto')
        expect(questao).not_to be_valid
        expect(questao.errors[:template]).to include("must exist")
      end
    end
  end
end