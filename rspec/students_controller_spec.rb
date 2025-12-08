require 'rails_helper'

RSpec.describe StudentsController, type: :request do
  let(:turma) { Turma.create(codigo_sigaa: 'ABC', semestre: '2024.1/2024') }
  let(:valid_attributes) { { name: 'Student Test', matricula: '123456', email: 'student@example.com', turma_id: turma.id } }

  describe 'GET /students' do
    it 'returns all students' do
      get '/students'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /students' do
    it 'creates a new student' do
      expect {
        post '/students', params: { student: valid_attributes }
      }.to change(Student, :count).by(1)
      expect(response).to have_http_status(:created)
    end
  end
end
