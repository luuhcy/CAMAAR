require 'rails_helper'

RSpec.describe Admin::ImportarController, type: :controller do
  
  # Testa erro quando não envia arquivo
  it 'retorna erro sem arquivo' do
    post :create, params: {}
    
    expect(response).to have_http_status(:bad_request)
    json = JSON.parse(response.body)
    expect(json['message']).to include('Nenhum arquivo')
  end
end