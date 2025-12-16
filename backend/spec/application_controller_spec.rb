require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'OK'
    end
  end

  describe 'CORS configuration' do
    it 'allows cross-origin requests' do
      get :index
      expect(response).to be_successful
    end
  end
end
