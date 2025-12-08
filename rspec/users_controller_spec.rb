require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password123', nome: 'Test User', tipo: 'student' } }

  describe 'GET /users' do
    it 'returns all users' do
      get '/users'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /users' do
    it 'creates a new user' do
      expect {
        post '/users', params: { user: valid_attributes }
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end
