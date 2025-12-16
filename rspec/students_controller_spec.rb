require 'rails_helper'

# Testes do controller de Students
RSpec.describe StudentsController, type: :request do
  let!(:turma) { Turma.create!(codigo_sigaa: 'ABC', nome: 'Turma Teste', disciplina: 'Disciplina', semestre: '2024.1') }
  let(:valid_attributes) { { name: 'Student Test', matricula: '123456', email: 'student@example.com', turma_id: turma.id } }

  describe 'GET /students' do
    context 'quando tem estudantes (Happy Path)' do
      let!(:student1) { Student.create!(name: 'Aluno 1', email: 'aluno1@test.com', matricula: '111', turma: turma) }
      let!(:student2) { Student.create!(name: 'Aluno 2', email: 'aluno2@test.com', matricula: '222', turma: turma) }

      it 'lista todos os estudantes' do
        get '/students'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end
    end

    context 'quando não tem estudantes (Sad Path)' do
      it 'retorna lista vazia' do
        get '/students'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'POST /students' do
    context 'com dados válidos (Happy Path)' do
      it 'cria um novo estudante' do
        expect {
          post '/students', params: { student: valid_attributes }
        }.to change(Student, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        post '/students', params: { student: { name: '', email: '', matricula: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'GET /students/:id' do
    let!(:student) { Student.create!(name: 'Aluno Teste', email: 'aluno@test.com', matricula: '123', turma: turma) }

    context 'quando estudante existe (Happy Path)' do
      it 'retorna o estudante específico' do
        get "/students/#{student.id}"
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq('Aluno Teste')
      end
    end

    context 'quando estudante não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/students/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /students/:id' do
    let!(:student) { Student.create!(name: 'Aluno Original', email: 'original@test.com', matricula: '123', turma: turma) }

    context 'com dados válidos (Happy Path)' do
      it 'atualiza o estudante' do
        put "/students/#{student.id}", params: { student: { name: 'Aluno Atualizado' } }
        expect(response).to have_http_status(:ok)
        student.reload
        expect(student.name).to eq('Aluno Atualizado')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        put "/students/#{student.id}", params: { student: { name: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /students/:id' do
    let!(:student) { Student.create!(name: 'Aluno para Deletar', email: 'delete@test.com', matricula: '123', turma: turma) }

    context 'quando estudante existe (Happy Path)' do
      it 'deleta o estudante' do
        expect {
          delete "/students/#{student.id}"
        }.to change(Student, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando estudante não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/students/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
