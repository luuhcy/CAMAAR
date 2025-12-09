require 'rails_helper'

# Testes do controller de Templates
RSpec.describe TemplatesController, type: :request do
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let(:valid_attributes) { { nome: 'Template Test', descricao: 'Description', user_id: user.id } }

  # Testa se lista todos os templates
  it 'lista todos os templates' do
    get '/templates'
    expect(response).to have_http_status(:success)
  end

  # Testa se cria um novo template
  it 'cria um novo template' do
    expect {
      post '/templates', params: { template: valid_attributes }
    }.to change(Template, :count).by(1)
    expect(response).to have_http_status(:created)
  end
end
