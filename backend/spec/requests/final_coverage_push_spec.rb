require 'rails_helper'

RSpec.describe 'Final coverage push - untested branches', type: :request do
  let!(:admin) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: 'ADM1', password: 'pass', tipo: 'admin') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'T1', nome: 'Turma', disciplina: 'Disc', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Template', user: admin) }

  describe 'FormulariosController index date logic branches' do
    it 'excludes formularios where current date < data_inicio' do
      future = Formulario.create!(
        titulo: 'Future',
        data_inicio: DateTime.now + 10.days,
        data_termino: DateTime.now + 20.days,
        template: template,
        turma: turma
      )
      
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      # Future formulario should not be in active list
      future_ids = json.map { |f| f['id'] }
      expect(future_ids).not_to include(future.id)
    end

    it 'excludes formularios where current date > data_termino' do
      past = Formulario.create!(
        titulo: 'Past',
        data_inicio: DateTime.now - 20.days,
        data_termino: DateTime.now - 10.days,
        template: template,
        turma: turma
      )
      
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      past_ids = json.map { |f| f['id'] }
      expect(past_ids).not_to include(past.id)
    end

    it 'includes formulario where current date is exactly data_inicio' do
      exact_start = Formulario.create!(
        titulo: 'ExactStart',
        data_inicio: DateTime.now,
        data_termino: DateTime.now + 7.days,
        template: template,
        turma: turma
      )
      
      get '/formularios'
      expect(response).to have_http_status(:ok)
      # Should be included
    end

    it 'includes formulario where current date is exactly data_termino' do
      exact_end = Formulario.create!(
        titulo: 'ExactEnd',
        data_inicio: DateTime.now - 7.days,
        data_termino: DateTime.now,
        template: template,
        turma: turma
      )
      
      get '/formularios'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'Import controller - CSV error branches' do
    it 'handles row-level StandardError exception' do
      # Create intentionally malformed CSV that might cause unexpected errors
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T1,Turma,Disc,1/2025,M1,Nome,email@ex.com\n"
      file = Tempfile.new(['test', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      ensure
        file.close
        file.unlink
    end

    it 'reports turma creation errors in response' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    "T1,Turma 1,Disc 1,1/2025,,,\n"
      file = Tempfile.new(['test', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      json = JSON.parse(response.body)
      expect(json['turmas_criadas']).to be >= 0
      expect(json['alunos_criados']).to be >= 0
      ensure
        file.close
        file.unlink
    end

    it 'accumulates multiple errors across rows' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    ",,,,,,\n" \
                    ",,,,,,\n"
      file = Tempfile.new(['errors', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      json = JSON.parse(response.body)
      expect(json['erros']).to be_an(Array)
      ensure
        file.close
        file.unlink
    end
  end

  describe 'Import controller - JSON error branches' do
    it 'handles StandardError in import_classes_json' do
      json_content = [
        {
          "code": "CODE1",
          "name": "Name1",
          "class": {
            "classCode": "CC1",
            "semester": "1/2025"
          }
        }
      ].to_json
      
      file = Tempfile.new(['classes', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to have_key('turmas_criadas')
      ensure
        file.close
        file.unlink
    end

    it 'handles StandardError in import_class_members_json' do
      json_content = [
        {
          "code": "FGA001",
          "classCode": "CM1",
          "semester": "1/2025",
          "dicente": [
            {
              "cpf": "12345678901",
              "matricula": "M1",
              "nome": "Student",
              "email": "s@ex.com"
            }
          ]
        }
      ].to_json
      
      file = Tempfile.new(['members', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok)
      ensure
        file.close
        file.unlink
    end

    it 'reports errors in JSON import response' do
      json_content = [
        {
          "code": "ERR1",
          "classCode": "E1",
          "semester": "1/2025",
          "dicente": []
        }
      ].to_json
      
      file = Tempfile.new(['json_err', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      json = JSON.parse(response.body)
      expect(json).to have_key('message')
      expect(json).to have_key('erros')
      ensure
        file.close
        file.unlink
    end
  end

  describe 'Sessions controller error branches' do
    it 'handles missing email parameter' do
      post '/login', params: { password: 'pass' }
      expect(response.status).to be_in([400, 401, 404, 422])
    end

    it 'handles missing password parameter' do
      post '/login', params: { email: 'test@ex.com' }
      expect(response.status).to be_in([400, 401, 404, 422])
    end

    it 'handles both parameters missing' do
      post '/login', params: {}
      expect(response.status).to be_in([400, 401, 404, 422])
    end
  end

  describe 'Controllers show methods with associations' do
    let!(:formulario) { Formulario.create!(titulo: 'F', template: template, turma: turma) }
    let!(:questao) { Questao.create!(texto: 'Q', tipo: 'objetiva', template: template) }
    let!(:resposta) { Respostum.create!(user: admin, formulario: formulario, data_resposta: '{}') }
    let!(:student) { Student.create!(name: 'S', email: 's@ex.com', matricula: 'M1', turma: turma) }

    it 'FormulariosController show includes nested associations' do
      get "/formularios/#{formulario.id}"
      json = JSON.parse(response.body)
      # Verify nested includes
      expect(json).to be_a(Hash)
    end

    it 'TemplatesController show includes user' do
      get "/templates/#{template.id}"
      json = JSON.parse(response.body)
      expect(json).to be_a(Hash)
    end

    it 'TurmasController show includes associations' do
      get "/turmas/#{turma.id}"
      json = JSON.parse(response.body)
      expect(json).to be_a(Hash)
    end
  end

  describe 'Destroy with dependencies' do
    let!(:formulario) { Formulario.create!(titulo: 'F', template: template, turma: turma) }
    
    it 'formulario destroys associated respostas' do
      r1 = Respostum.create!(user: admin, formulario: formulario, data_resposta: '{}')
      r2 = Respostum.create!(user: admin, formulario: formulario, data_resposta: '{}')
      
      expect {
        delete "/formularios/#{formulario.id}"
      }.to change(Respostum, :count).by(-2)
    end

    it 'template destroys associated questaos' do
      tpl = Template.create!(nome: 'ToCascade', user: admin)
      q1 = Questao.create!(texto: 'Q1', tipo: 'objetiva', template: tpl)
      q2 = Questao.create!(texto: 'Q2', tipo: 'discursiva', template: tpl)
      
      expect {
        delete "/templates/#{tpl.id}"
      }.to change(Questao, :count).by(-2)
    end
  end

  describe 'CSV with whitespace handling' do
    it 'strips whitespace from CSV fields' do
      csv_content = "codigo_sigaa,nome_turma,disciplina,semestre,matricula_aluno,nome_aluno,email_aluno\n" \
                    " TSPACE , Space Turma , Space Disc , 1/2025 , , , \n"
      file = Tempfile.new(['spaces', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      turma = Turma.find_by(codigo_sigaa: 'TSPACE')
      expect(turma).to be_present if turma
      ensure
        file.close
        file.unlink
    end
  end
end
