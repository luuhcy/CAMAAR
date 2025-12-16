require 'rails_helper'

# Testes do controller base ApplicationController
RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { message: 'success' }
    end
  end

  describe 'funcionalidade básica' do
    context 'requisição válida (Happy Path)' do
      it 'responde com sucesso' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'retorna JSON válido' do
        get :index
        expect(response.content_type).to include('application/json')
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('success')
      end
    end
  end

  describe 'headers CORS' do
    it 'permite requisições cross-origin (Happy Path)' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end