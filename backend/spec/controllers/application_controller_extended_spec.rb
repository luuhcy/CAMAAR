require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: { message: 'OK' }
    end
  end
  
  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end
  
  it 'returns successful response' do
    get :index
    expect(response).to have_http_status(:success)
  end
  
  it 'returns JSON content type' do
    get :index
    expect(response.content_type).to include('application/json')
  end
  
  # CORS is handled at rack level, not controller level
end
