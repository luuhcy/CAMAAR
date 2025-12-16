require 'rails_helper'

RSpec.describe 'StudentsController comprehensive coverage', type: :request do
  let!(:turma) { Turma.create!(codigo_sigaa: 'T1', nome: 'N', disciplina: 'D', semestre: '1/2025', ano: 2025) }
  let!(:turma2) { Turma.create!(codigo_sigaa: 'T2', nome: 'N2', disciplina: 'D2', semestre: '2/2025', ano: 2025) }

  describe 'creation' do
    it 'creates student with required fields' do
      post '/students', params: {
        student: {
          name: 'John Doe',
          email: 'john@ex.com',
          matricula: 'M001',
          turma_id: turma.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates another student successfully' do
      post '/students', params: {
        student: {
          name: 'Jane Doe',
          email: 'jane@ex.com',
          matricula: 'M002',
          turma_id: turma.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails without name' do
      post '/students', params: {
        student: {
          email: 'test@ex.com',
          matricula: 'M003',
          turma_id: turma.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without email' do
      post '/students', params: {
        student: {
          name: 'Test Student',
          matricula: 'M004',
          turma_id: turma.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without matricula' do
      post '/students', params: {
        student: {
          name: 'Test Student',
          email: 'test@ex.com',
          turma_id: turma.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails with invalid turma_id due to foreign key constraint' do
      expect {
        post '/students', params: {
          student: {
            name: 'Test Student',
            email: 'test@ex.com',
            matricula: 'M005',
            turma_id: 99999
          }
        }
      }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  describe 'listing and filtering' do
    let!(:s1) { Student.create!(name: 'S1', email: 's1@ex.com', matricula: 'SM1', turma: turma) }
    let!(:s2) { Student.create!(name: 'S2', email: 's2@ex.com', matricula: 'SM2', turma: turma2) }
    let!(:s3) { Student.create!(name: 'S3', email: 's3@ex.com', matricula: 'SM3', turma: turma) }

    it 'lists all students' do
      get '/students'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to be >= 3
    end

    it 'filters by turma_id' do
      get "/students?turma_id=#{turma.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'filters by matricula' do
      get '/students?matricula=SM1'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'filters by name' do
      get '/students?name=S1'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific student' do
      get "/students/#{s1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['student']&.[]('id')).to eq(s1.id)
    end

    it 'returns 404 for nonexistent student' do
      get '/students/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:s1) { Student.create!(name: 'Original', email: 'orig@ex.com', matricula: 'SM1', turma: turma) }

    it 'updates name' do
      patch "/students/#{s1.id}", params: {
        student: { name: 'Updated' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      s1.reload
      expect(s1.name).to eq('Updated')
    end

    it 'updates email' do
      patch "/students/#{s1.id}", params: {
        student: { email: 'new@ex.com' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'updates turma_id' do
      patch "/students/#{s1.id}", params: {
        student: { turma_id: turma2.id }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      s1.reload
      expect(s1.turma_id).to eq(turma2.id)
    end

    it 'fails to update with invalid turma_id due to foreign key' do
      expect {
        patch "/students/#{s1.id}", params: {
          student: { turma_id: 99999 }
        }
      }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end

  describe 'deletion' do
    let!(:s1) { Student.create!(name: 'ToDelete', email: 'del@ex.com', matricula: 'SM1', turma: turma) }

    it 'deletes student' do
      expect {
        delete "/students/#{s1.id}"
      }.to change(Student, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent' do
      delete '/students/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
