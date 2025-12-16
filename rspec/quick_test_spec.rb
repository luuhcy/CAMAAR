require 'rails_helper'

# Testes essenciais para validação rápida do sistema
RSpec.describe 'Quick System Validation', type: :request do
  
  describe 'Core Models' do
    it 'cria e valida todos os models principais' do
      # User
      user = User.create!(nome: 'Test User', email: 'test@test.com', password: 'senha123', tipo: 'professor', matricula: '123456')
      expect(user).to be_valid
      
      # Template
      template = Template.create!(nome: 'Template Test', user: user)
      expect(template).to be_valid
      
      # Turma
      turma = Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma Test', disciplina: 'Disciplina', semestre: '2024.1')
      expect(turma).to be_valid
      
      # Student
      student = Student.create!(name: 'Student Test', email: 'student@test.com', matricula: '111', turma: turma)
      expect(student).to be_valid
      
      # Questao
      questao = Questao.create!(texto: 'Pergunta?', tipo: 'texto', template: template)
      expect(questao).to be_valid
      
      # Formulario
      formulario = Formulario.create!(titulo: 'Form Test', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma)
      expect(formulario).to be_valid
      
      # Respostum
      resposta = Respostum.create!(data_resposta: {'1' => 'Resposta'}, status: 'enviado', user: user, formulario: formulario)
      expect(resposta).to be_valid
    end
  end
  
  describe 'Core Controllers' do
    let!(:user) { User.create!(nome: 'Test User', email: 'test@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma Test', disciplina: 'Disciplina', semestre: '2024.1') }
    
    it 'testa endpoints principais' do
      # Users
      get '/users'
      expect(response).to have_http_status(:success)
      
      # Turmas
      get '/turmas'
      expect(response).to have_http_status(:success)
      
      # Templates
      get '/templates'
      expect(response).to have_http_status(:success)
      
      # Students
      get '/students'
      expect(response).to have_http_status(:success)
      
      # Formularios
      get '/formularios'
      expect(response).to have_http_status(:success)
      
      # Questaos
      get '/questaos'
      expect(response).to have_http_status(:success)
      
      # Respostas
      get '/respostas'
      expect(response).to have_http_status(:success)
    end
  end
  
  describe 'Authentication' do
    let!(:user) { User.create!(nome: 'Test User', email: 'test@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    
    it 'autentica usuário válido' do
      post '/login', params: { email: 'test@test.com', password: 'senha123' }
      expect(response).to have_http_status(:success)
    end
    
    it 'rejeita credenciais inválidas' do
      post '/login', params: { email: 'test@test.com', password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end