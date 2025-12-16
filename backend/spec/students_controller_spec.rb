require 'rails_helper'

# Testes do controller de Students
RSpec.describe StudentsController, type: :request do
  let(:turma) { Turma.create(codigo_sigaa: 'ABC', semestre: '2024.1/2024') }
  let(:valid_attributes) { { name: 'Student Test', matricula: '123456', email: 'student@example.com', turma_id: turma.id } }

  # Testa se lista todos os estudantes
  it 'lista todos os estudantes' do
    get '/students'
    expect(response).to have_http_status(:success)
  end

  # Testa se cria um novo estudante
  it 'cria um novo estudante' do
    expect {
      post '/students', params: { student: valid_attributes }
    }.to change(Student, :count).by(1)
    expect(response).to have_http_status(:created)
  end
end
