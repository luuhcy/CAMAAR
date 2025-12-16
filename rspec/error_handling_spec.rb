require 'rails_helper'

# Testes de tratamento de erros para aumentar cobertura
RSpec.describe 'Error Handling Coverage', type: :request do
  
  describe 'ApplicationController error handling' do
    context 'erros de parâmetros' do
      it 'trata parâmetros inválidos graciosamente' do
        post '/users', params: { invalid: 'data' }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  
  describe 'Sessions controller error paths' do
    context 'parâmetros ausentes' do
      it 'falha sem email' do
        post '/login', params: { password: 'senha' }
        expect(response).to have_http_status(:unauthorized)
      end
      
      it 'falha sem password' do
        post '/login', params: { email: 'test@test.com' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  describe 'Admin::ImportarController error paths' do
    context 'diferentes tipos de erro' do
      it 'falha com arquivo vazio' do
        post '/admin/importar', params: {}
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  
  describe 'Controllers com IDs inválidos' do
    context 'IDs não numéricos' do
      it 'falha com ID não numérico em users' do
        get '/users/abc'
        expect(response).to have_http_status(:not_found)
      end
      
      it 'falha com ID não numérico em templates' do
        get '/templates/xyz'
        expect(response).to have_http_status(:not_found)
      end
      
      it 'falha com ID não numérico em students' do
        get '/students/invalid'
        expect(response).to have_http_status(:not_found)
      end
      
      it 'falha com ID não numérico em turmas' do
        get '/turmas/bad_id'
        expect(response).to have_http_status(:not_found)
      end
      
      it 'falha com ID não numérico em formularios' do
        get '/formularios/wrong'
        expect(response).to have_http_status(:not_found)
      end
      
      it 'falha com ID não numérico em questaos' do
        get '/questaos/error'
        expect(response).to have_http_status(:not_found)
      end
      
      it 'falha com ID não numérico em respostas' do
        get '/respostas/fail'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end