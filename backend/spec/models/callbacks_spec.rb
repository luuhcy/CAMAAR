require 'rails_helper'

RSpec.describe 'Model callbacks and methods', type: :model do
  describe 'Turma' do
    it 'extracts ano from semestre with format "1/2025"' do
      turma = Turma.create!(codigo_sigaa: 'TST001', nome: 'Test', disciplina: 'Test', semestre: '1/2025')
      expect(turma.ano).to eq(2025)
    end
    
    it 'extracts ano from semestre with format "2024.2/2024"' do
      turma = Turma.create!(codigo_sigaa: 'TST002', nome: 'Test', disciplina: 'Test', semestre: '2024.2/2024')
      expect(turma.ano).to eq(2024)
    end
    
    it 'handles invalid semestre format gracefully' do
      turma = Turma.new(codigo_sigaa: 'TST003', nome: 'Test', disciplina: 'Test', semestre: 'invalid')
      turma.save(validate: false)
      expect(turma.ano).to be_nil
    end
  end
  
  describe 'Student' do
    let(:turma) { Turma.create!(codigo_sigaa: 'FGA0138', nome: 'Compiladores', disciplina: 'Compiladores', semestre: '1/2025', ano: 2025) }
    
    it 'can exist without a turma (optional association)' do
      student = Student.new(name: 'Test Student', email: 'test@example.com', matricula: '999999')
      expect(student).to be_valid
    end
    
    it 'maintains association when turma is assigned' do
      student = Student.create!(name: 'Student', email: 'student@example.com', matricula: '888888', turma: turma)
      expect(student.turma.codigo_sigaa).to eq('FGA0138')
    end
  end
  
  describe 'User password encryption' do
    it 'does not store password in plain text' do
      user = User.create!(nome: 'Test', email: 'test@example.com', matricula: '123', password: 'secretpassword', tipo: 'admin')
      expect(user.password_digest).not_to eq('secretpassword')
      expect(user.password_digest).to be_present
      expect(user.password_digest.length).to be > 20
    end
    
    it 'allows authentication with correct password' do
      user = User.create!(nome: 'Test', email: 'test2@example.com', matricula: '456', password: 'mypassword', tipo: 'admin')
      expect(user.authenticate('mypassword')).to eq(user)
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
  
  describe 'Template dependent destroy' do
    let(:user) { User.create!(nome: 'Admin', email: 'admin@example.com', matricula: '111', password: 'pass', tipo: 'admin') }
    let(:template) { Template.create!(nome: 'Template', descricao: 'Desc', user: user) }
    
    it 'destroys associated questoes when template is destroyed' do
      q1 = Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
      q2 = Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template)
      
      expect { template.destroy }.to change(Questao, :count).by(-2)
    end
  end
  
  describe 'Formulario associations' do
    let(:user) { User.create!(nome: 'Admin', email: 'admin2@example.com', matricula: '222', password: 'pass', tipo: 'admin') }
    let(:turma) { Turma.create!(codigo_sigaa: 'TST004', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025) }
    let(:template) { Template.create!(nome: 'Template', descricao: 'Desc', user: user) }
    let(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma) }
    
    it 'destroys associated respostas when formulario is destroyed' do
      user2 = User.create!(nome: 'User', email: 'user@example.com', matricula: '333', password: 'pass', tipo: 'student')
      Respostum.create!(user: user2, formulario: formulario, data_resposta: 'response 1')
      Respostum.create!(user: user, formulario: formulario, data_resposta: 'response 2')
      
      expect { formulario.destroy }.to change(Respostum, :count).by(-2)
    end
  end
end
