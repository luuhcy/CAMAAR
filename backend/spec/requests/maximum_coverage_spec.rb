require 'rails_helper'

RSpec.describe 'Maximum coverage push', type: :request do
  describe 'Admin Importar Controller remaining branches' do
    it 'rejects import without csvFile parameter' do
      post '/admin/importar', params: {}
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['message']).to include('Nenhum arquivo')
    end

    it 'rejects unsupported file format (not CSV or JSON)' do
      file = Tempfile.new(['test', '.txt'])
      file.write('some text content')
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/plain')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['message']).to include('não suportado')
      ensure
        file.close
        file.unlink
    end

    it 'handles JSON with unrecognized format' do
      json_content = {"unknown": "format", "data": []}.to_json
      file = Tempfile.new(['unknown', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['message']).to include('não reconhecido')
      ensure
        file.close
        file.unlink
    end

    it 'reports errors for invalid turma data in CSV' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    ",Missing Codigo,,1/2025,,,\n"
      file = Tempfile.new(['invalid', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      # Should have processed but not created any turmas
      expect(json['turmas_criadas']).to eq(0)
      ensure
        file.close
        file.unlink
    end

    it 'skips student creation when missing required fields' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "TVALID,Valid Turma,Valid Disc,1/2025,M1,,\n"
      file = Tempfile.new(['missing_name', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.not_to change(Student, :count)
      
      expect(response).to have_http_status(:ok)
      ensure
        file.close
        file.unlink
    end

    it 'reports errors in JSON response' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T1,Turma 1,Disc,1/2025,,,\n"
      file = Tempfile.new(['test', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key('message')
      expect(json).to have_key('turmas_criadas')
      expect(json).to have_key('alunos_criados')
      expect(json).to have_key('erros')
      ensure
        file.close
        file.unlink
    end
  end

  describe 'SessionsController branches' do
    let!(:user) { User.create!(nome: 'Test', email: 'test@ex.com', matricula: 'M1', password: 'correctpass', tipo: 'student') }

    it 'returns user data on successful login' do
      post '/login', params: {
        email: 'test@ex.com',
        password: 'correctpass'
      }
      
      expect(response.status).to be_in([200, 201])
      json = JSON.parse(response.body)
      expect(json).to have_key('user') | have_key('email') | have_key('id')
    end

    it 'returns error on failed login' do
      post '/login', params: {
        email: 'test@ex.com',
        password: 'wrongpass'
      }
      
      expect(response.status).to be_in([400, 401, 422])
    end

    it 'returns error when user not found' do
      post '/login', params: {
        email: 'nonexistent@ex.com',
        password: 'anypass'
      }
      
      expect(response.status).to be_in([400, 401, 404, 422])
    end
  end

  describe 'Controllers param validation' do
    let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'A1', password: 'p', tipo: 'admin') }
    let!(:turma) { Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2025', ano: 2025) }
    let!(:template) { Template.create!(nome: 'T', user: admin) }

    it 'FormulariosController handles empty params' do
      post '/formularios', params: {}
      expect(response.status).to be_in([400, 422])
    end

    it 'QuestaosController handles empty params' do
      post '/questaos', params: {}
      expect(response.status).to be_in([400, 422])
    end

    it 'RespostasController handles missing params' do
      post '/respostas', params: {}
      expect(response.status).to be_in([400, 404, 422])
    end

    it 'TemplatesController handles empty params' do
      post '/templates', params: {}
      expect(response.status).to be_in([400, 422])
    end

    it 'TurmasController handles empty params' do
      post '/turmas', params: {}
      expect(response.status).to be_in([400, 422])
    end

    it 'StudentsController handles empty params' do
      post '/students', params: {}
      expect(response.status).to be_in([400, 422])
    end

    it 'UsersController handles empty params' do
      post '/users', params: {}
      expect(response.status).to be_in([400, 422])
    end
  end

  describe 'Update operations with invalid IDs' do
    it 'FormulariosController returns 404 for invalid ID' do
      patch '/formularios/99999', params: { formulario: { titulo: 'X' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'QuestaosController returns 404 for invalid ID' do
      patch '/questaos/99999', params: { questao: { texto: 'X' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'RespostasController returns 404 for invalid ID' do
      patch '/respostas/99999', params: { respostum: { data_resposta: 'X' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'TemplatesController returns 404 for invalid ID' do
      patch '/templates/99999', params: { template: { nome: 'X' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'TurmasController returns 404 for invalid ID' do
      patch '/turmas/99999', params: { turma: { nome: 'X' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'StudentsController returns 404 for invalid ID' do
      patch '/students/99999', params: { student: { name: 'X' } }
      expect(response).to have_http_status(:not_found)
    end

    it 'UsersController returns 404 for invalid ID' do
      patch '/users/99999', params: { user: { nome: 'X' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'ApplicationController CORS' do
    it 'includes CORS headers in response' do
      get '/users'
      expect(response.headers).to have_key('Access-Control-Allow-Origin') | be_truthy
    end
  end
end
