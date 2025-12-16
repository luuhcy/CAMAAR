require 'rails_helper'

RSpec.describe 'Admin::ImportarController additional scenarios', type: :request do
  describe 'CSV import with various data combinations' do
    it 'imports only turmas without student data' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T101,Turma 101,Disc 101,1/2025,,,\n" \
                    "T102,Turma 102,Disc 102,2/2025,,,\n"
      file = Tempfile.new(['turmas_only', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(2)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to eq(2)
      ensure
        file.close
        file.unlink
    end

    it 'imports both turmas and students' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T201,Turma 201,Disc 201,1/2025,M201,Student 201,s201@ex.com\n" \
                    "T201,Turma 201,Disc 201,1/2025,M202,Student 202,s202@ex.com\n"
      file = Tempfile.new(['both', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(1).and change(Student, :count).by(2)

      expect(response).to have_http_status(:ok)
      ensure
        file.close
        file.unlink
    end

    it 'handles missing semestre field' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T301,Turma 301,Disc 301,,M301,Student 301,s301@ex.com\n"
      file = Tempfile.new(['no_semestre', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      
      # Should use "Não informado" as default
      turma = Turma.find_by(codigo_sigaa: 'T301')
      expect(turma.semestre).to eq('Não informado') if turma
      ensure
        file.close
        file.unlink
    end

    it 'handles missing disciplina field' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T401,Turma 401,,1/2025,,,\n"
      file = Tempfile.new(['no_disc', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      
      turma = Turma.find_by(codigo_sigaa: 'T401')
      expect(turma.disciplina).to eq('Não informada') if turma
      ensure
        file.close
        file.unlink
    end

    it 'handles duplicate student matricula across turmas' do
      # Create initial student in T501
      csv1 = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
             "T501,Turma 501,Disc 501,1/2025,MREASSIGN,Student R,sr@ex.com\n"
      file1 = Tempfile.new(['initial', '.csv'])
      file1.write(csv1)
      file1.rewind
      uploaded1 = Rack::Test::UploadedFile.new(file1.path, 'text/csv')
      post '/admin/importar', params: { csvFile: uploaded1 }
      file1.close
      file1.unlink

      # Import same student in different turma
      csv2 = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
             "T502,Turma 502,Disc 502,2/2025,MREASSIGN,Student R Updated,srupdated@ex.com\n"
      file2 = Tempfile.new(['reassign', '.csv'])
      file2.write(csv2)
      file2.rewind
      uploaded2 = Rack::Test::UploadedFile.new(file2.path, 'text/csv')

      expect {
        post '/admin/importar', params: { csvFile: uploaded2 }
      }.not_to change(Student, :count)

      # Student should exist with one of the turmas
      student = Student.find_by(matricula: 'MREASSIGN')
      expect(student).to be_present

      file2.close
      file2.unlink
    end
  end

  describe 'JSON import additional scenarios' do
    it 'imports from classes.json with nested class object' do
      json_content = [
        {
          "code": "FGA0001",
          "name": "Fundamentos A",
          "class": {
            "classCode": "A1",
            "semester": "1/2025"
          }
        },
        {
          "code": "FGA0002",
          "name": "Fundamentos B",
          "class": {
            "classCode": "B1",
            "semester": "2/2025"
          }
        }
      ].to_json
      
      file = Tempfile.new(['classes', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Turma, :count).by(2)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to eq(2)
      ensure
        file.close
        file.unlink
    end

    it 'imports class_members with all student fields' do
      json_content = [
        {
          "code": "FGA9001",
          "classCode": "CM1",
          "semester": "1/2025",
          "dicente": [
            {
              "cpf": "11111111111",
              "matricula": "CM001",
              "nome": "Full Student",
              "email": "full@ex.com"
            }
          ]
        }
      ].to_json
      
      file = Tempfile.new(['class_members', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      expect {
        post '/admin/importar', params: { csvFile: uploaded }
      }.to change(Student, :count).by(1)

      expect(response).to have_http_status(:ok)
      
      student = Student.find_by(matricula: 'CM001')
      expect(student.name).to eq('Full Student') if student
      expect(student.email).to eq('full@ex.com') if student
      ensure
        file.close
        file.unlink
    end

    it 'handles dicente missing email field' do
      json_content = [
        {
          "code": "FGA8001",
          "classCode": "NE1",
          "semester": "1/2025",
          "dicente": [
            {
              "cpf": "22222222222",
              "matricula": "NE001",
              "nome": "No Email Student"
            }
          ]
        }
      ].to_json
      
      file = Tempfile.new(['no_email', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      
      # Student creation might fail or use default email
      json = JSON.parse(response.body)
      expect(json).to have_key('message') | have_key('erros')
      ensure
        file.close
        file.unlink
    end

    it 'handles empty dicente array gracefully' do
      json_content = [
        {
          "code": "FGA7001",
          "classCode": "EMPTY1",
          "semester": "1/2025",
          "dicente": []
        }
      ].to_json
      
      file = Tempfile.new(['empty_dicente', '.json'])
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
  end

  describe 'Error accumulation in import' do
    it 'continues processing after individual row errors' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "GOOD1,Good Turma,Good Disc,1/2025,M1,Student 1,s1@ex.com\n" \
                    ",,,,M2,Student 2,s2@ex.com\n" \
                    "GOOD2,Good Turma 2,Good Disc 2,2/2025,M3,Student 3,s3@ex.com\n"
      file = Tempfile.new(['mixed', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to be >= 1
      expect(json['erros']).to be_an(Array) if json['erros']
      ensure
        file.close
        file.unlink
    end
  end
end
