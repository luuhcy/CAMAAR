require 'rails_helper'

RSpec.describe 'QuestaosController comprehensive coverage', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }
  let!(:template) { Template.create!(nome: 'Tpl', descricao: 'D', user: admin) }

  describe 'creation' do
    it 'creates questao with required fields' do
      post '/questaos', params: {
        questao: {
          texto: 'What is 2+2?',
          tipo: 'objetiva',
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates questao with opcoes' do
      post '/questaos', params: {
        questao: {
          texto: 'Choose one',
          tipo: 'objetiva',
          opcoes: '["A","B","C","D"]',
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates discursiva questao' do
      post '/questaos', params: {
        questao: {
          texto: 'Explain something',
          tipo: 'discursiva',
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails without texto' do
      post '/questaos', params: {
        questao: {
          tipo: 'objetiva',
          template_id: template.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without tipo' do
      post '/questaos', params: {
        questao: {
          texto: 'Some question',
          template_id: template.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without template_id' do
      post '/questaos', params: {
        questao: {
          texto: 'Some question',
          tipo: 'objetiva'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'handles invalid tipo gracefully' do
      post '/questaos', params: {
        questao: {
          texto: 'Question',
          tipo: 'invalid_type',
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201, 400, 422].include?(s) }
    end
  end

  describe 'listing' do
    let!(:q1) { Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template) }
    let!(:q2) { Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template) }

    it 'lists all questaos' do
      get '/questaos'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to be >= 2
    end

    it 'filters by template_id' do
      get "/questaos?template_id=#{template.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific questao' do
      get "/questaos/#{q1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['questao']&.[]('id')).to eq(q1.id)
    end

    it 'returns 404 for nonexistent questao' do
      get '/questaos/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:q1) { Questao.create!(texto: 'Original', tipo: 'objetiva', template: template) }

    it 'updates texto' do
      patch "/questaos/#{q1.id}", params: {
        questao: { texto: 'Updated Question' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      q1.reload
      expect(q1.texto).to eq('Updated Question')
    end

    it 'updates opcoes' do
      patch "/questaos/#{q1.id}", params: {
        questao: { opcoes: '["New1","New2","New3"]' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'fails to update with invalid template_id' do
      patch "/questaos/#{q1.id}", params: {
        questao: { template_id: 99999 }
      }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'deletion' do
    let!(:q1) { Questao.create!(texto: 'ToDelete', tipo: 'objetiva', template: template) }

    it 'deletes questao' do
      expect {
        delete "/questaos/#{q1.id}"
      }.to change(Questao, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent' do
      delete '/questaos/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
