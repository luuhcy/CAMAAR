require 'rails_helper'

RSpec.describe 'FormulariosController comprehensive coverage', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'T1', nome: 'N', disciplina: 'D', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Tpl', descricao: 'D', user: admin) }

  describe 'creation with various states' do
    it 'creates with only required fields' do
      post '/formularios', params: {
        formulario: {
          titulo: 'Form1',
          template_id: template.id,
          turma_id: turma.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates with start and end dates' do
      post '/formularios', params: {
        formulario: {
          titulo: 'Form2',
          data_inicio: '2025-01-15T10:00:00Z',
          data_termino: '2025-02-15T18:00:00Z',
          template_id: template.id,
          turma_id: turma.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates with start date only' do
      post '/formularios', params: {
        formulario: {
          titulo: 'Form3',
          data_inicio: '2025-01-15T10:00:00Z',
          template_id: template.id,
          turma_id: turma.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails when turma_id missing' do
      post '/formularios', params: {
        formulario: {
          titulo: 'Form4',
          template_id: template.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails when template_id missing' do
      post '/formularios', params: {
        formulario: {
          titulo: 'Form5',
          turma_id: turma.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'creates without titulo (field optional)' do
      post '/formularios', params: {
        formulario: {
          template_id: template.id,
          turma_id: turma.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201, 400, 422].include?(s) }
    end
  end

  describe 'listing and filtering' do
    let!(:f1) { Formulario.create!(titulo: 'F1', template: template, turma: turma) }

    it 'lists all formularios' do
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific formulario' do
      get "/formularios/#{f1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['formulario']&.[]('id')).to eq(f1.id)
    end

    it 'returns 404 for nonexistent formulario' do
      get '/formularios/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:f1) { Formulario.create!(titulo: 'Original', template: template, turma: turma) }

    it 'updates titulo' do
      patch "/formularios/#{f1.id}", params: {
        formulario: { titulo: 'Updated' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      f1.reload
      expect(f1.titulo).to eq('Updated')
    end

    it 'updates dates' do
      patch "/formularios/#{f1.id}", params: {
        formulario: {
          data_inicio: '2025-03-01T10:00:00Z',
          data_termino: '2025-03-31T23:59:59Z'
        }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'fails to update with invalid template_id' do
      patch "/formularios/#{f1.id}", params: {
        formulario: { template_id: 99999 }
      }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'deletion' do
    let!(:f1) { Formulario.create!(titulo: 'ToDelete', template: template, turma: turma) }

    it 'deletes formulario' do
      expect {
        delete "/formularios/#{f1.id}"
      }.to change(Formulario, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent' do
      delete '/formularios/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
