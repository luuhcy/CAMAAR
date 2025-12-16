require 'rails_helper'

# Testes do controller de Users
RSpec.describe UsersController, type: :request do
  let(:valid_attributes) { { email: 'test@example.com', password: 'password123', nome: 'Test User', tipo: 'aluno', matricula: '111111' } }

  describe 'GET /users' do
    context 'quando tem usuários (Happy Path)' do
      let!(:user1) { User.create!(nome: 'User 1', email: 'user1@test.com', password: '123456', tipo: 'aluno', matricula: '111') }
      let!(:user2) { User.create!(nome: 'User 2', email: 'user2@test.com', password: '123456', tipo: 'professor', matricula: '222') }

      it 'lista todos os usuários' do
        get '/users'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end
    end

    context 'quando não tem usuários (Sad Path)' do
      it 'retorna lista vazia' do
        get '/users'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'GET /users/:id' do
    let!(:user) { User.create!(nome: 'User Teste', email: 'user@test.com', password: '123456', tipo: 'aluno', matricula: '123') }

    context 'quando usuário existe (Happy Path)' do
      it 'retorna o usuário específico' do
        get "/users/#{user.id}"
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['nome']).to eq('User Teste')
      end
    end

    context 'quando usuário não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/users/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /users' do
    context 'com dados válidos (Happy Path)' do
      it 'cria um novo usuário' do
        expect {
          post '/users', params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        post '/users', params: { user: { nome: '', email: '', password: '', matricula: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'retorna erro com email duplicado' do
        User.create!(valid_attributes)
        post '/users', params: { user: valid_attributes.merge(matricula: '222222') }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT /users/:id' do
    let!(:user) { User.create!(nome: 'User Original', email: 'original@test.com', password: '123456', tipo: 'aluno', matricula: '123') }

    context 'com dados válidos (Happy Path)' do
      it 'atualiza o usuário' do
        put "/users/#{user.id}", params: { user: { nome: 'User Atualizado' } }
        expect(response).to have_http_status(:ok)
        user.reload
        expect(user.nome).to eq('User Atualizado')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        put "/users/#{user.id}", params: { user: { nome: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /users/:id' do
    let!(:user) { User.create!(nome: 'User para Deletar', email: 'delete@test.com', password: '123456', tipo: 'aluno', matricula: '123') }

    context 'quando usuário existe (Happy Path)' do
      it 'deleta o usuário' do
        expect {
          delete "/users/#{user.id}"
        }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando usuário não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/users/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
