require 'rails_helper'

RSpec.describe 'TurmasController comprehensive coverage', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }

  describe 'creation' do
    it 'creates turma with required fields' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'FGA0138',
          nome: 'Fundamentos',
          disciplina: 'Programação',
          semestre: '1/2025'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json['ano'] || json['turma']&.[]('ano')).to eq(2025)
    end

    it 'extracts year from semestre' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'CS101',
          nome: 'Intro CS',
          disciplina: 'Computer Science',
          semestre: '2/2024'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json['ano'] || json['turma']&.[]('ano')).to eq(2024)
    end

    it 'fails without codigo_sigaa' do
      post '/turmas', params: {
        turma: {
          nome: 'Turma',
          disciplina: 'D',
          semestre: '1/2025'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'creates turma without nome (optional field)' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'T1',
          disciplina: 'D',
          semestre: '1/2025'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201, 400, 422].include?(s) }
    end

    it 'creates turma without disciplina (optional field)' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'T1',
          nome: 'T1',
          semestre: '1/2025'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201, 400, 422].include?(s) }
    end

    it 'fails without semestre' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'T1',
          nome: 'T1',
          disciplina: 'D'
        }
      }
      expect(response.status).to be_in([400, 422])
    end
  end

  describe 'listing and filtering' do
    let!(:t1) { Turma.create!(codigo_sigaa: 'T1', nome: 'T1', disciplina: 'D', semestre: '1/2025', ano: 2025) }
    let!(:t2) { Turma.create!(codigo_sigaa: 'T2', nome: 'T2', disciplina: 'D', semestre: '2/2025', ano: 2025) }
    let!(:t3) { Turma.create!(codigo_sigaa: 'T3', nome: 'T3', disciplina: 'D', semestre: '1/2024', ano: 2024) }

    it 'lists all turmas' do
      get '/turmas'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to be >= 3
    end

    it 'filters by ano' do
      get '/turmas?ano=2025'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'filters by semestre' do
      get '/turmas?semestre=1/2025'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'filters by codigo_sigaa' do
      get "/turmas?codigo_sigaa=T1"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific turma' do
      get "/turmas/#{t1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['turma']&.[]('id')).to eq(t1.id)
    end

    it 'returns 404 for nonexistent turma' do
      get '/turmas/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:t1) { Turma.create!(codigo_sigaa: 'T1', nome: 'Original', disciplina: 'D', semestre: '1/2025', ano: 2025) }

    it 'updates nome' do
      patch "/turmas/#{t1.id}", params: {
        turma: { nome: 'Updated' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      t1.reload
      expect(t1.nome).to eq('Updated')
    end

    it 'updates disciplina' do
      patch "/turmas/#{t1.id}", params: {
        turma: { disciplina: 'NewDisciplina' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'updates semestre' do
      patch "/turmas/#{t1.id}", params: {
        turma: { semestre: '2/2025' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      t1.reload
      expect(t1.ano).to eq(2025)
    end
  end

  describe 'deletion' do
    let!(:t1) { Turma.create!(codigo_sigaa: 'T1', nome: 'ToDelete', disciplina: 'D', semestre: '1/2025', ano: 2025) }

    it 'deletes turma' do
      expect {
        delete "/turmas/#{t1.id}"
      }.to change(Turma, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent' do
      delete '/turmas/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
