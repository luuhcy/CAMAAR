require 'rails_helper'

RSpec.describe 'Questaos API', type: :request do
  let(:user) { User.create!(nome: 'Admin', email: 'admin@example.com', matricula: '111', password: 'pass', tipo: 'admin') }
  let(:template) { Template.create!(nome: 'Template', descricao: 'Desc', user: user) }
  
  describe 'GET /questaos' do
    it 'returns all questions' do
      Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
      Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template)
      
      get '/questaos'
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json.length).to be >= 2
    end
    
    it 'filters questions by template_id' do
      template2 = Template.create!(nome: 'Template 2', descricao: 'Desc', user: user)
      
      Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
      Questao.create!(texto: 'Q2', tipo: 'objetiva', template: template2)
      
      get "/questaos?template_id=#{template.id}"
      expect(response).to have_http_status(:success)
    end
  end
  
  describe 'GET /questaos/:id' do
    it 'returns a specific question' do
      questao = Questao.create!(texto: 'Test Question', tipo: 'objetiva', template: template)
      
      get "/questaos/#{questao.id}"
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['texto']).to eq('Test Question')
    end
  end
  
  describe 'POST /questaos' do
    it 'creates a new question' do
      expect {
        post '/questaos', params: {
          questao: {
            texto: 'New Question',
            tipo: 'objetiva',
            template_id: template.id,
            obrigatoria: true,
            ordem: 1
          }
        }
      }.to change(Questao, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
    
    it 'creates question with opcoes' do
      post '/questaos', params: {
        questao: {
          texto: 'Choose one',
          tipo: 'objetiva',
          template_id: template.id,
          opcoes: '["A", "B", "C", "D"]'
        }
      }
      
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['opcoes']).to be_present
    end
  end
  
  describe 'PATCH /questaos/:id' do
    it 'updates a question' do
      questao = Questao.create!(texto: 'Old Question', tipo: 'objetiva', template: template)
      
      patch "/questaos/#{questao.id}", params: {
        questao: { texto: 'Updated Question' }
      }
      
      expect(response).to have_http_status(:success)
      questao.reload
      expect(questao.texto).to eq('Updated Question')
    end
    
    it 'updates question ordem' do
      questao = Questao.create!(texto: 'Question', tipo: 'objetiva', template: template, ordem: 1)
      
      patch "/questaos/#{questao.id}", params: {
        questao: { ordem: 5 }
      }
      
      questao.reload
      expect(questao.ordem).to eq(5)
    end
  end
  
  describe 'DELETE /questaos/:id' do
    it 'deletes a question' do
      questao = Questao.create!(texto: 'To Delete', tipo: 'objetiva', template: template)
      
      expect {
        delete "/questaos/#{questao.id}"
      }.to change(Questao, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end
