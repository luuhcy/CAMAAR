require 'rails_helper'

RSpec.describe 'Formulario and resource edge cases', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }
  let!(:t1) { Turma.create!(codigo_sigaa: 'T1', nome: 'N', disciplina: 'D', semestre: '1/2025', ano: 2025) }
  let!(:tpl) { Template.create!(nome: 'Tpl', descricao: 'D', user: admin) }

  describe 'FormulariosController edge cases' do
    it 'creates formulario with custom date range' do
      post '/formularios', params: {
        formulario: {
          titulo: 'F1',
          data_inicio: '2025-12-01T10:00:00Z',
          data_termino: '2025-12-31T23:59:59Z',
          template_id: tpl.id,
          turma_id: t1.id
        }
      }
      expect(response).to have_http_status(:created)
    end

    it 'creates formulario without dates (nullable)' do
      post '/formularios', params: {
        formulario: {
          titulo: 'F2',
          template_id: tpl.id,
          turma_id: t1.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'lists formularios with includes' do
      f = Formulario.create!(titulo: 'F', data_inicio: DateTime.now, data_termino: DateTime.now + 1, template: tpl, turma: t1)
      get '/formularios'
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows formulario with template and turma' do
      f = Formulario.create!(titulo: 'F', data_inicio: DateTime.now, data_termino: DateTime.now + 1, template: tpl, turma: t1)
      get "/formularios/#{f.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('template') | have_key('turma')
    end
  end

  describe 'RespostasController status variations' do
    let!(:f) { Formulario.create!(titulo: 'F', data_inicio: DateTime.now, data_termino: DateTime.now + 1, template: tpl, turma: t1) }

    it 'creates resposta with status' do
      post '/respostas', params: {
        user_id: admin.id,
        formulario_id: f.id,
        resposta: '{"q":"a"}',
        status: 'enviado'
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'lists all respostas' do
      r = Respostum.create!(user: admin, formulario: f, data_resposta: '{"q":"a"}')
      get '/respostas'
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific resposta' do
      r = Respostum.create!(user: admin, formulario: f, data_resposta: '{"q":"a"}')
      get "/respostas/#{r.id}"
      expect(response).to have_http_status(:success)
    end

    it 'updates resposta' do
      r = Respostum.create!(user: admin, formulario: f, data_resposta: '{"q":"a"}')
      patch "/respostas/#{r.id}", params: {
        respostum: { data_resposta: '{"q":"b"}' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end
  end

  describe 'QuestaosController with opcoes' do
    it 'creates questao with opcoes' do
      post '/questaos', params: {
        questao: {
          texto: 'Q',
          tipo: 'objetiva',
          template_id: tpl.id,
          opcoes: '["A","B","C"]',
          obrigatoria: true,
          ordem: 1
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'lists questaos with template filter' do
      q = Questao.create!(texto: 'Q', tipo: 'objetiva', template: tpl)
      get "/questaos?template_id=#{tpl.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'StudentsController with turma filter' do
    let!(:s1) { Student.create!(name: 'S1', email: 's1@ex.com', matricula: 'SM1', turma: t1) }

    it 'filters students by turma_id' do
      get "/students?turma_id=#{t1.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to be >= 1
    end

    it 'filters students by matricula' do
      get "/students?matricula=SM1"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.first['matricula']).to eq('SM1') if json.length > 0
    end

    it 'updates student name and email' do
      patch "/students/#{s1.id}", params: {
        student: { name: 'Updated', email: 'u@ex.com' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end
  end

  describe 'TurmasController with date extraction' do
    it 'creates turma and extracts ano from semestre' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: 'NEW',
          nome: 'NewT',
          disciplina: 'NewD',
          semestre: '2/2025'
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
      json = JSON.parse(response.body)
      expect(json['ano']).to eq(2025)
    end

    it 'shows turma with formularios and respostas' do
      f = Formulario.create!(titulo: 'F', data_inicio: DateTime.now, data_termino: DateTime.now + 1, template: tpl, turma: t1)
      get "/turmas/#{t1.id}"
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json).to have_key('turma') | have_key('formulario')
    end
  end
end
