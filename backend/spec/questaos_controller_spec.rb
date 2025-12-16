require 'rails_helper'

RSpec.describe QuestaosController, type: :controller do
  let(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '123456', password: 'password', tipo: 'admin') }
  let(:template) { Template.create!(nome: 'Template Teste', descricao: 'Descrição', user: user) }
  
  let(:valid_attributes) do
    {
      texto: 'Pergunta de teste?',
      tipo: 'radio',
      obrigatoria: true,
      ordem: 1,
      opcoes: ['Sim', 'Não'].to_json,
      template_id: template.id
    }
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      questao = Questao.create!(valid_attributes)
      get :show, params: { id: questao.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Questao' do
        expect {
          post :create, params: { questao: valid_attributes }
        }.to change(Questao, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { questao: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'PATCH #update' do
    let(:questao) { Questao.create!(valid_attributes) }
    
    it 'updates the questao' do
      patch :update, params: { id: questao.id, questao: { texto: 'Nova pergunta?' } }
      questao.reload
      expect(questao.texto).to eq('Nova pergunta?')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested questao' do
      questao = Questao.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: questao.id }
      }.to change(Questao, :count).by(-1)
    end
  end
end
