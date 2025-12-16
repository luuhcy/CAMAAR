require 'rails_helper'

RSpec.describe 'UsersController comprehensive coverage', type: :request do
  describe 'creation' do
    it 'creates user with all required fields' do
      post '/users', params: {
        user: {
          nome: 'John Doe',
          email: 'john@example.com',
          matricula: '123456',
          password: 'securepassword',
          tipo: 'student'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json['email'] || json['user']&.[]('email')).to eq('john@example.com')
    end

    it 'creates admin user' do
      post '/users', params: {
        user: {
          nome: 'Admin User',
          email: 'admin@example.com',
          matricula: '999999',
          password: 'adminpass',
          tipo: 'admin'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails without nome' do
      post '/users', params: {
        user: {
          email: 'test@example.com',
          matricula: '111111',
          password: 'password',
          tipo: 'student'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without email' do
      post '/users', params: {
        user: {
          nome: 'Test User',
          matricula: '222222',
          password: 'password',
          tipo: 'student'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without matricula' do
      post '/users', params: {
        user: {
          nome: 'Test User',
          email: 'test@example.com',
          password: 'password',
          tipo: 'student'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without password' do
      post '/users', params: {
        user: {
          nome: 'Test User',
          email: 'test@example.com',
          matricula: '333333',
          tipo: 'student'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails with duplicate email' do
      User.create!(nome: 'First', email: 'duplicate@example.com', matricula: '444444', password: 'pass', tipo: 'student')
      
      post '/users', params: {
        user: {
          nome: 'Second',
          email: 'duplicate@example.com',
          matricula: '555555',
          password: 'pass',
          tipo: 'student'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails with duplicate matricula' do
      User.create!(nome: 'First', email: 'first@example.com', matricula: 'DUP123', password: 'pass', tipo: 'student')
      
      post '/users', params: {
        user: {
          nome: 'Second',
          email: 'second@example.com',
          matricula: 'DUP123',
          password: 'pass',
          tipo: 'student'
        }
      }
      expect(response.status).to be_in([400, 422])
    end
  end

  describe 'listing' do
    let!(:user1) { User.create!(nome: 'User1', email: 'user1@example.com', matricula: 'M1', password: 'pass', tipo: 'student') }
    let!(:user2) { User.create!(nome: 'User2', email: 'user2@example.com', matricula: 'M2', password: 'pass', tipo: 'admin') }

    it 'lists all users' do
      get '/users'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to be >= 2
    end

    it 'filters by tipo' do
      get '/users?tipo=admin'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific user' do
      get "/users/#{user1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['user']&.[]('id')).to eq(user1.id)
    end

    it 'returns 404 for nonexistent user' do
      get '/users/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:user) { User.create!(nome: 'Original', email: 'orig@example.com', matricula: 'ORIG', password: 'pass', tipo: 'student') }

    it 'updates nome' do
      patch "/users/#{user.id}", params: {
        user: { nome: 'Updated Name' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      user.reload
      expect(user.nome).to eq('Updated Name')
    end

    it 'updates email' do
      patch "/users/#{user.id}", params: {
        user: { email: 'newemail@example.com' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'updates tipo' do
      patch "/users/#{user.id}", params: {
        user: { tipo: 'admin' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      user.reload
      expect(user.tipo).to eq('admin')
    end

    it 'updates password' do
      patch "/users/#{user.id}", params: {
        user: { password: 'newpassword123' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'fails to update with duplicate email' do
      User.create!(nome: 'Other', email: 'other@example.com', matricula: 'OTHER', password: 'pass', tipo: 'student')
      
      patch "/users/#{user.id}", params: {
        user: { email: 'other@example.com' }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails to update with duplicate matricula' do
      User.create!(nome: 'Other', email: 'other2@example.com', matricula: 'OTHERMAT', password: 'pass', tipo: 'student')
      
      patch "/users/#{user.id}", params: {
        user: { matricula: 'OTHERMAT' }
      }
      expect(response.status).to be_in([400, 422])
    end
  end

  describe 'deletion' do
    let!(:user) { User.create!(nome: 'ToDelete', email: 'delete@example.com', matricula: 'DEL', password: 'pass', tipo: 'student') }

    it 'deletes user' do
      expect {
        delete "/users/#{user.id}"
      }.to change(User, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent user' do
      delete '/users/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
