require 'rails_helper'

# Testes do controller de Turmas
RSpec.describe TurmasController, type: :request do
  let(:valid_attributes) { { codigo_sigaa: 'ABC123', nome: 'Turma A', semestre: '2024.1/2024' } }

  # Testa se lista todas as turmas
  it 'lista todas as turmas' do
    get '/turmas'
    expect(response).to have_http_status(:success)
  end

  # Testa se cria uma nova turma
  it 'cria uma nova turma' do
    expect {
      post '/turmas', params: { turma: valid_attributes }
    }.to change(Turma, :count).by(1)
    expect(response).to have_http_status(:created)
  end
end
