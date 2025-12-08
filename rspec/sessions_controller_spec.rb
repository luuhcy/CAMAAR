require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let!(:user) { User.create(email: 'test@example.com', password: 'password123', nome: 'Test') }

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'returns success' do
        post '/login', params: { email: user.email, password: 'password123' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login realizado!')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post '/login', params: { email: user.email, password: 'wrong' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
