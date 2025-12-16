require 'rails_helper'

RSpec.describe 'Authentication flow', type: :request do
  describe 'user login and authentication' do
    let!(:user) { User.create!(nome: 'Test User', email: 'test@example.com', matricula: '123456', password: 'password123', tipo: 'admin') }
    
    it 'allows user to login with valid credentials' do
      post '/login', params: { email: user.email, password: 'password123' }
      expect(response).to have_http_status(:success)
      
      json_response = JSON.parse(response.body)
      expect(json_response['user']).to be_present
      expect(json_response['user']['email']).to eq(user.email)
    end
    
    it 'rejects login with invalid credentials' do
      post '/login', params: { email: user.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
    end
    
    it 'returns error for non-existent user' do
      post '/login', params: { email: 'nonexistent@example.com', password: 'password' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe 'user registration' do
    it 'creates a new user with valid data' do
      expect {
        post '/users', params: {
          user: {
            nome: 'New User',
            email: 'newuser@example.com',
            matricula: '654321',
            password: 'newpassword',
            tipo: 'student'
          }
        }
      }.to change(User, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
    
    it 'rejects user creation with invalid data' do
      expect {
        post '/users', params: {
          user: {
            nome: '',
            email: 'invalid',
            matricula: '',
            password: 'pass'
          }
        }
      }.not_to change(User, :count)
    end
  end
end
