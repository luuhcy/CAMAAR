require 'rails_helper'

# Testes do controller de Users
RSpec.describe UsersController, type: :request do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password123', nome: 'Test User', tipo: 'student' } }

  # Testa se lista todos os usuários
  it 'lista todos os usuários' do
    get '/users'
    expect(response).to have_http_status(:success)
  end

  # Testa se cria um novo usuário
  it 'cria um novo usuário' do
    expect {
      post '/users', params: { user: valid_attributes }
    }.to change(User, :count).by(1)
    expect(response).to have_http_status(:created)
  end
end
