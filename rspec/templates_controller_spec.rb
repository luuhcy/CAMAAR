require 'rails_helper'

RSpec.describe TemplatesController, type: :request do
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let(:valid_attributes) { { nome: 'Template Test', descricao: 'Description', user_id: user.id } }

  describe 'GET /templates' do
    it 'returns all templates' do
      get '/templates'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /templates' do
    it 'creates a new template' do
      expect {
        post '/templates', params: { template: valid_attributes }
      }.to change(Template, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end
