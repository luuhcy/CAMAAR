require 'rails_helper'

RSpec.describe TurmasController, type: :controller do
  let!(:turma) { Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '1º/2024') }

  # Testa listar turmas
  it 'lista todas as turmas' do
    get :index
    
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.length).to eq(1)
  end

  # Testa mostrar uma turma
  it 'mostra turma específica' do
    get :show, params: { id: turma.id }
    
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['codigo_sigaa']).to eq('CIC001')
  end

  # Testa criar turma
  it 'cria nova turma' do
    params = {
      turma: {
        codigo_sigaa: 'CIC002',
        nome: 'Turma B',
        semestre: '1º/2024'
      }
    }
    
    post :create, params: params
    
    expect(response).to have_http_status(:created)
    expect(Turma.count).to eq(2)
  end

  # Testa erro ao criar turma inválida
  it 'não cria turma sem código' do
    params = {
      turma: {
        nome: 'Turma Sem Código'
      }
    }
    
    post :create, params: params
    
    expect(response).to have_http_status(:unprocessable_content)
  end
end