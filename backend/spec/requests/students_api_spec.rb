require 'rails_helper'

RSpec.describe 'Students API', type: :request do
  let(:turma) { Turma.create!(codigo_sigaa: 'FGA0138', nome: 'Compiladores', disciplina: 'Compiladores', semestre: '1/2025', ano: 2025) }
  
  describe 'GET /students' do
    it 'returns all students' do
      Student.create!(name: 'João', email: 'joao@test.com', matricula: '111', turma: turma)
      Student.create!(name: 'Maria', email: 'maria@test.com', matricula: '222', turma: turma)
      
      get '/students'
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json.length).to be >= 2
    end
    
    it 'filters students by turma_id' do
      turma2 = Turma.create!(codigo_sigaa: 'TST001', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      
      Student.create!(name: 'Student 1', email: 's1@test.com', matricula: '333', turma: turma)
      Student.create!(name: 'Student 2', email: 's2@test.com', matricula: '444', turma: turma2)
      
      get "/students?turma_id=#{turma.id}"
      expect(response).to have_http_status(:success)
    end
    
    it 'finds student by matricula' do
      student = Student.create!(name: 'Test Student', email: 'test@test.com', matricula: '200012345', turma: turma)
      
      get "/students?matricula=200012345"
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json.first['matricula']).to eq('200012345')
    end
  end
  
  describe 'GET /students/:id' do
    it 'returns a specific student' do
      student = Student.create!(name: 'João Silva', email: 'joao@test.com', matricula: '555', turma: turma)
      
      get "/students/#{student.id}"
      expect(response).to have_http_status(:success)
      
      json = JSON.parse(response.body)
      expect(json['name']).to eq('João Silva')
    end
  end
  
  describe 'POST /students' do
    it 'creates a new student' do
      expect {
        post '/students', params: {
          student: {
            name: 'New Student',
            email: 'new@test.com',
            matricula: '666',
            turma_id: turma.id
          }
        }
      }.to change(Student, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
    
    it 'rejects student with duplicate matricula' do
      Student.create!(name: 'Existing', email: 'existing@test.com', matricula: '777', turma: turma)
      
      post '/students', params: {
        student: {
          name: 'Duplicate',
          email: 'duplicate@test.com',
          matricula: '777',
          turma_id: turma.id
        }
      }
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'PATCH /students/:id' do
    it 'updates a student' do
      student = Student.create!(name: 'Old Name', email: 'old@test.com', matricula: '888', turma: turma)
      
      patch "/students/#{student.id}", params: {
        student: { name: 'New Name' }
      }
      
      expect(response).to have_http_status(:success)
      student.reload
      expect(student.name).to eq('New Name')
    end
  end
  
  describe 'DELETE /students/:id' do
    it 'deletes a student' do
      student = Student.create!(name: 'To Delete', email: 'delete@test.com', matricula: '999', turma: turma)
      
      expect {
        delete "/students/#{student.id}"
      }.to change(Student, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end
