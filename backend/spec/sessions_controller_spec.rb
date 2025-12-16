require 'rails_helper'

# Testes do controller de Sessions (login)
RSpec.describe SessionsController, type: :request do
  let!(:user) { User.create(email: 'test@example.com', password: 'password123', nome: 'Test', matricula: 'SESS001', tipo: 'admin') }

  # Testa login com senha correta
  it 'faz login com sucesso' do
    post '/login', params: { email: user.email, password: 'password123' }
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)['message']).to eq('Login realizado!')
  end

  # Testa login com senha errada
  it 'retorna erro com senha errada' do
    post '/login', params: { email: user.email, password: 'wrong' }
    expect(response).to have_http_status(:unauthorized)
  end
end
