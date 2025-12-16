require 'rails_helper'

# Testes do model Respostum
RSpec.describe Respostum, type: :model do
  let(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '123456', password: 'password', tipo: 'admin') }
  let(:turma) { Turma.create!(codigo_sigaa: 'TST001', nome: 'Turma', disciplina: 'Disc', semestre: '1/2025', ano: 2025) }
  let(:template) { Template.create!(nome: 'Template', descricao: 'Desc', user: user) }
  let(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma) }
  
  # Testa se as associações tão funcionando
  it { should belong_to(:user) }
  it { should belong_to(:formulario) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      resposta = Respostum.new(user: user, formulario: formulario, data_resposta: '{"q1": "resposta 1"}')
      expect(resposta).to be_valid
    end
    
    it 'is invalid without a user' do
      resposta = Respostum.new(user: nil, formulario: formulario, data_resposta: '{"q1": "resposta"}')
      expect(resposta).to_not be_valid
    end
    
    it 'is invalid without a formulario' do
      resposta = Respostum.new(user: user, formulario: nil, data_resposta: '{"q1": "resposta"}')
      expect(resposta).to_not be_valid
    end
  end
  
  describe 'data_resposta field' do
    it 'can store JSON data' do
      resposta = Respostum.create!(user: user, formulario: formulario, data_resposta: '{"pergunta1": "resposta1", "pergunta2": "resposta2"}')
      expect(resposta.data_resposta).to be_a(String)
      expect(resposta.data_resposta).to include('pergunta1')
    end
    
    it 'can store text responses' do
      resposta = Respostum.create!(user: user, formulario: formulario, data_resposta: 'Resposta em texto livre')
      expect(resposta.data_resposta).to eq('Resposta em texto livre')
    end
  end
  
  describe 'associations' do
    it 'belongs to a user' do
      resposta = Respostum.create!(user: user, formulario: formulario, data_resposta: 'test')
      expect(resposta.user).to eq(user)
    end
    
    it 'belongs to a formulario' do
      resposta = Respostum.create!(user: user, formulario: formulario, data_resposta: 'test')
      expect(resposta.formulario).to eq(formulario)
    end
    
    it 'allows multiple responses from different users to the same formulario' do
      user2 = User.create!(nome: 'User2', email: 'user2@test.com', matricula: '654321', password: 'pass', tipo: 'student')
      
      resp1 = Respostum.create!(user: user, formulario: formulario, data_resposta: 'resposta user1')
      resp2 = Respostum.create!(user: user2, formulario: formulario, data_resposta: 'resposta user2')
      
      expect(formulario.respostas.count).to eq(2)
      expect(formulario.respostas).to include(resp1, resp2)
    end
  end
end
