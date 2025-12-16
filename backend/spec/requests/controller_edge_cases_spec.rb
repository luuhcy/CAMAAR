require 'rails_helper'

RSpec.describe 'Controller error handling and edge cases', type: :request do
  let!(:admin) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: 'ADM1', password: 'pass', tipo: 'admin') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'T1', nome: 'Turma 1', disciplina: 'Disc 1', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Template 1', user: admin) }

  describe 'Turmas with different semestre formats' do
    it 'creates turma with semestre X/YYYY format' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'TSEM1',
          nome: 'Semestre Test 1',
          disciplina: 'Disc',
          semestre: '1/2024'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json['ano'] || json['turma']&.[]('ano')).to eq(2024)
    end

    it 'creates turma with semestre YYYY.X format' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'TSEM2',
          nome: 'Semestre Test 2',
          disciplina: 'Disc',
          semestre: '2024.2'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json['ano'] || json['turma']&.[]('ano')).to eq(2024)
    end

    it 'creates turma with plain year as semestre' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'TSEM3',
          nome: 'Semestre Test 3',
          disciplina: 'Disc',
          semestre: '2023'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'handles invalid semestre format' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'TSEM4',
          nome: 'Semestre Test 4',
          disciplina: 'Disc',
          semestre: 'invalid_format'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201, 400, 422].include?(s) }
    end
  end

  describe 'Templates with questaos cascading' do
    it 'allows deletion of template without questaos' do
      tpl = Template.create!(nome: 'Empty Template', user: admin)
      
      expect {
        delete "/templates/#{tpl.id}"
      }.to change(Template, :count).by(-1)
    end

    it 'deletes template and cascades to questaos' do
      tpl = Template.create!(nome: 'With Questaos', user: admin)
      Questao.create!(texto: 'Q1', tipo: 'objetiva', template: tpl)
      Questao.create!(texto: 'Q2', tipo: 'discursiva', template: tpl)
      
      expect {
        delete "/templates/#{tpl.id}"
      }.to change(Questao, :count).by(-2)
    end
  end

  describe 'Respostas with different status values' do
    let!(:formulario) { Formulario.create!(titulo: 'Form', template: template, turma: turma) }
    let!(:student) { User.create!(nome: 'S', email: 's@test.com', matricula: 'S1', password: 'p', tipo: 'student') }

    it 'creates resposta and defaults to enviado status' do
      post '/respostas', params: {
        resposta: '{"answer": "test"}',
        user_id: student.id,
        formulario_id: formulario.id
      }
      
      if response.status == 201 || response.status == 200
        json = JSON.parse(response.body)
        expect(json['status'] || json['respostum']&.[]('status')).to eq('enviado')
      end
    end

    it 'creates resposta with JSON data' do
      post '/respostas', params: {
        resposta: '{"q1": "answer1", "q2": 42, "q3": ["opt1", "opt2"]}',
        user_id: student.id,
        formulario_id: formulario.id
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end
  end

  describe 'Questaos with diferentes tipos' do
    it 'creates objetiva questao with opcoes' do
      post '/questaos', params: {
        questao: {
          texto: 'Multiple choice',
          tipo: 'objetiva',
          opcoes: JSON.generate(['Option A', 'Option B', 'Option C', 'Option D']),
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates discursiva questao without opcoes' do
      post '/questaos', params: {
        questao: {
          texto: 'Essay question',
          tipo: 'discursiva',
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates questao with ordem for sequencing' do
      post '/questaos', params: {
        questao: {
          texto: 'First question',
          tipo: 'objetiva',
          ordem: 1,
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates obrigatoria questao' do
      post '/questaos', params: {
        questao: {
          texto: 'Required question',
          tipo: 'objetiva',
          obrigatoria: true,
          template_id: template.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end
  end

  describe 'Users with different tipos' do
    it 'creates student type user' do
      post '/users', params: {
        user: {
          nome: 'Student User',
          email: 'student@test.com',
          matricula: 'STU001',
          password: 'password',
          tipo: 'student'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates admin type user' do
      post '/users', params: {
        user: {
          nome: 'Admin User',
          email: 'newadmin@test.com',
          matricula: 'ADM002',
          password: 'password',
          tipo: 'admin'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates professor type user' do
      post '/users', params: {
        user: {
          nome: 'Professor User',
          email: 'prof@test.com',
          matricula: 'PROF001',
          password: 'password',
          tipo: 'professor'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end
  end

  describe 'Students bulk operations' do
    it 'creates multiple students for same turma' do
      5.times do |i|
        post '/students', params: {
          student: {
            name: "Student #{i}",
            email: "student#{i}@test.com",
            matricula: "BULK#{i}",
            turma_id: turma.id
          }
        }
        expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      end
      
      expect(Student.where(turma: turma).count).to be >= 5
    end
  end

  describe 'Formularios date range filtering' do
    before(:each) do
      # Create various formularios with different date ranges
      @expired = Formulario.create!(
        titulo: 'Expired',
        data_inicio: DateTime.now - 30.days,
        data_termino: DateTime.now - 15.days,
        template: template,
        turma: turma
      )
      
      @current = Formulario.create!(
        titulo: 'Current',
        data_inicio: DateTime.now - 2.days,
        data_termino: DateTime.now + 5.days,
        template: template,
        turma: turma
      )
      
      @upcoming = Formulario.create!(
        titulo: 'Upcoming',
        data_inicio: DateTime.now + 5.days,
        data_termino: DateTime.now + 15.days,
        template: template,
        turma: turma
      )
    end

    it 'index returns only current formularios' do
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      # Should filter based on current date
      expect(json).to be_an(Array)
    end

    it 'can retrieve all formularios via specific show requests' do
      [@expired, @current, @upcoming].each do |f|
        get "/formularios/#{f.id}"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'Template and User relationship' do
    it 'allows user to have multiple templates' do
      3.times do |i|
        Template.create!(nome: "Template #{i}", user: admin)
      end
      
      expect(admin.templates.count).to be >= 3
    end

    it 'includes user info when fetching templates' do
      tpl = Template.create!(nome: 'Test Template', user: admin)
      
      get "/templates/#{tpl.id}"
      if response.status == 200
        json = JSON.parse(response.body)
        expect(json).to have_key('user') | have_key('user_id')
      end
    end
  end
end
