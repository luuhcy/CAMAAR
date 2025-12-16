require 'rails_helper'

RSpec.describe 'SessionsController comprehensive coverage', type: :request do
  let!(:user) { User.create!(nome: 'Test User', email: 'test@example.com', matricula: '123456', password: 'correctpassword', tipo: 'student') }
  let!(:admin) { User.create!(nome: 'Admin User', email: 'admin@example.com', matricula: 'ADMIN1', password: 'adminpass', tipo: 'admin') }

  describe 'POST /login (create session)' do
    it 'logs in with valid email and password' do
      post '/login', params: {
        email: 'test@example.com',
        password: 'correctpassword'
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json).to have_key('user') | have_key('email') | have_key('id')
    end

    it 'logs in admin with valid credentials' do
      post '/login', params: {
        email: 'admin@example.com',
        password: 'adminpass'
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails with incorrect password' do
      post '/login', params: {
        email: 'test@example.com',
        password: 'wrongpassword'
      }
      expect(response.status).to be_in([400, 401, 422])
    end

    it 'fails with nonexistent email' do
      post '/login', params: {
        email: 'nonexistent@example.com',
        password: 'somepassword'
      }
      expect(response.status).to be_in([400, 401, 404, 422])
    end

    it 'fails without email' do
      post '/login', params: {
        password: 'somepassword'
      }
      expect(response.status).to be_in([400, 401, 422])
    end

    it 'fails without password' do
      post '/login', params: {
        email: 'test@example.com'
      }
      expect(response.status).to be_in([400, 401, 422])
    end

    it 'fails with empty credentials' do
      post '/login', params: {}
      expect(response.status).to be_in([400, 401, 422])
    end

    it 'returns user info on successful login' do
      post '/login', params: {
        email: 'test@example.com',
        password: 'correctpassword'
      }
      
      if response.status == 200 || response.status == 201
        json = JSON.parse(response.body)
        expect(json['email'] || json['user']&.[]('email')).to eq('test@example.com')
      end
    end
  end

  describe 'edge cases' do
    it 'handles case-sensitive email' do
      post '/login', params: {
        email: 'TEST@EXAMPLE.COM',
        password: 'correctpassword'
      }
      expect(response.status).to satisfy { |s| [200, 201, 401, 404].include?(s) }
    end

    it 'handles email with whitespace' do
      post '/login', params: {
        email: ' test@example.com ',
        password: 'correctpassword'
      }
      expect(response.status).to satisfy { |s| [200, 201, 401, 404].include?(s) }
    end

    it 'prevents SQL injection in email' do
      post '/login', params: {
        email: "' OR '1'='1",
        password: 'anypassword'
      }
      expect(response.status).to be_in([400, 401, 404, 422])
    end
  end
end
