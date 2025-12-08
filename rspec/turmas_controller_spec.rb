require 'rails_helper'

RSpec.describe TurmasController, type: :request do
  let(:valid_attributes) { { codigo_sigaa: 'ABC123', nome: 'Turma A', semestre: '2024.1/2024' } }

  describe 'GET /turmas' do
    it 'returns all turmas' do
      get '/turmas'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /turmas' do
    it 'creates a new turma' do
      expect {
        post '/turmas', params: { turma: valid_attributes }
      }.to change(Turma, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end
