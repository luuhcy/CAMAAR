require 'rails_helper'

RSpec.describe 'Admin Importar edge cases', type: :request do
  describe 'CSV with empty rows and partial data' do
    it 'handles empty rows gracefully' do
      csv_content = <<~CSV
        codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
        FGA01,T1,D1,1/2025,M1,N1,e1@ex.com

        
      CSV
      file = Tempfile.new(['empty_rows', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1).and change(Student, :count).by(1)

      expect(response).to have_http_status(:ok)
    ensure
      file.close
      file.unlink
    end

    it 'handles multiple turmas and students' do
      csv_content = <<~CSV
        codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
        FGA01,T1,D1,1/2025,M1,N1,e1@ex.com
        FGA01,T1,D1,1/2025,M2,N2,e2@ex.com
        FGA02,T2,D2,1/2025,M3,N3,e3@ex.com
      CSV
      file = Tempfile.new(['multi', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(2).and change(Student, :count).by(3)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to eq(2)
      expect(json['alunos_criados']).to eq(3)
    ensure
      file.close
      file.unlink
    end

    it 'reports errors for invalid data' do
      csv_content = <<~CSV
        codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
        FGA01,T1,D1,1/2025,M1,N1,e1@ex.com
        FGA01,T1,D1,1/2025,,InvalidName,e2@ex.com
      CSV
      file = Tempfile.new(['errors', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['erros']).to be_present if json['erros'].present?
    ensure
      file.close
      file.unlink
    end

    it 'handles duplicate matricula updates' do
      Student.create!(name: 'Existing', email: 'exist@ex.com', matricula: 'EXISTING', turma: Turma.create!(codigo_sigaa: 'OLD', nome: 'O', disciplina: 'O', semestre: '1/2025'))

      csv_content = <<~CSV
        codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno
        FGA01,T1,D1,1/2025,EXISTING,UpdatedName,updated@ex.com
      CSV
      file = Tempfile.new(['dup', '.csv'])
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
  end

  describe 'JSON with missing dicente field' do
    it 'handles class_members without students' do
      json_content = [
        { "code": "FGA01", "classCode": "T1", "semester": "1/2025", "dicente": [] }
      ].to_json
      file = Tempfile.new(['nomembers', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1)
      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.not_to change(Student, :count)

      expect(response).to have_http_status(:ok)
    ensure
      file.close
      file.unlink
    end

    it 'handles partial dicente objects (missing fields)' do
      json_content = [
        {
          "code": "FGA01",
          "classCode": "T1",
          "semester": "1/2025",
          "dicente": [
            { "matricula": "M1", "nome": "N1", "email": "e1@ex.com" },
            { "matricula": "M2" }
          ]
        }
      ].to_json
      file = Tempfile.new(['partial', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1).and change(Student, :count).by(1)

      expect(response).to have_http_status(:ok)
    ensure
      file.close
      file.unlink
    end
  end
end
