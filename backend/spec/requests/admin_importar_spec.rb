require 'rails_helper'

RSpec.describe 'Admin Importar', type: :request do
  describe 'POST /admin/importar' do
    it 'returns bad_request when no file uploaded' do
      post '/admin/importar'
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['message']).to include('Nenhum arquivo enviado')
    end

    it 'rejects unsupported file type' do
      file = Tempfile.new(['data', '.txt'])
      file.write('invalid content')
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/plain')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json['message']).to include('Formato de arquivo não suportado')
    ensure
      file.close
      file.unlink
    end

    it 'imports CSV successfully' do
      csv_content = <<~CSV
        codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
        FGA0138,Compiladores,Compiladores,1/2025,200012345,Joao Silva,joao@example.com
      CSV
      file = Tempfile.new(['import', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1).and change(Student, :count).by(1)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to eq(1)
      expect(json['alunos_criados']).to eq(1)
    ensure
      file.close
      file.unlink
    end

    it 'imports classes.json successfully' do
      json_content = [
        { "code": "FGA0138", "name": "Compiladores", "class": { "classCode": "T1", "semester": "1/2025" } }
      ].to_json
      file = Tempfile.new(['classes', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to eq(1)
    ensure
      file.close
      file.unlink
    end

    it 'imports class_members.json successfully' do
      json_content = [
        { "code": "FGA0138", "classCode": "T1", "semester": "1/2025", "dicente": [ { "matricula": "200012345", "nome": "Joao", "email": "joao@example.com" } ] }
      ].to_json
      file = Tempfile.new(['members', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1).and change(Student, :count).by(1)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to eq(1)
      expect(json['alunos_criados']).to eq(1)
    ensure
      file.close
      file.unlink
    end
  end
end
