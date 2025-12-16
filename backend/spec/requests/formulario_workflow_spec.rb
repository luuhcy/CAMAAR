require 'rails_helper'

RSpec.describe 'Formulario workflow', type: :request do
  let!(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '999999', password: 'password', tipo: 'admin') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'FGA0138', nome: 'Compiladores', disciplina: 'Compiladores', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Avaliação Padrão', descricao: 'Template de avaliação', user: user) }
  let!(:questao) { Questao.create!(texto: 'Como você avalia?', tipo: 'objetiva', template: template) }
  let!(:formulario) { Formulario.create!(titulo: 'Avaliação 1', data_inicio: DateTime.now, data_termino: DateTime.now + 7.days, template: template, turma: turma) }
  
  describe 'viewing formularios' do
    it 'lists all formularios' do
      get '/formularios'
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to be >= 1
    end
    
    it 'shows a specific formulario with details' do
      get "/formularios/#{formulario.id}"
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
      expect(json_response['titulo']).to eq('Avaliação 1')
      expect(json_response['turma']).to be_present
      expect(json_response['template']).to be_present
    end
  end
  
  describe 'submitting responses' do
    it 'creates a response for a formulario' do
      expect {
        post '/respostas', params: {
          user_id: user.id,
          formulario_id: formulario.id,
          resposta: '{"q1": "Muito bom"}'
        }
      }.to change(Respostum, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
    
    it 'lists responses for a formulario' do
      Respostum.create!(user: user, formulario: formulario, data_resposta: '{"q1": "Excelente"}')
      
      get '/respostas'
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
    end
  end
  
  describe 'managing turmas and students' do
    it 'lists all turmas' do
      get '/turmas'
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.first['codigo_sigaa']).to eq('FGA0138')
    end
    
    it 'shows a specific turma' do
      get "/turmas/#{turma.id}"
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
      expect(json_response['turma']['codigo_sigaa']).to eq('FGA0138')
    end
    
    it 'creates a student in a turma' do
      expect {
        post '/students', params: {
          student: {
            name: 'João Silva',
            email: 'joao@example.com',
            matricula: '200012345',
            turma_id: turma.id
          }
        }
      }.to change(Student, :count).by(1)
    end
  end
end
