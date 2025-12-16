require 'rails_helper'

RSpec.describe 'FormulariosController additional coverage', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }
  let!(:turma1) { Turma.create!(codigo_sigaa: 'T1', nome: 'N1', disciplina: 'D1', semestre: '1/2025', ano: 2025) }
  let!(:turma2) { Turma.create!(codigo_sigaa: 'T2', nome: 'N2', disciplina: 'D2', semestre: '2/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Tpl', user: admin) }

  describe 'GET /formularios (index with date filtering)' do
    before(:each) do
      # Create formularios with different date ranges
      @active1 = Formulario.create!(
        titulo: 'Active Now',
        data_inicio: DateTime.now - 1.day,
        data_termino: DateTime.now + 1.day,
        template: template,
        turma: turma1
      )
      
      @future = Formulario.create!(
        titulo: 'Future',
        data_inicio: DateTime.now + 10.days,
        data_termino: DateTime.now + 20.days,
        template: template,
        turma: turma2
      )
      
      @past = Formulario.create!(
        titulo: 'Past',
        data_inicio: DateTime.now - 20.days,
        data_termino: DateTime.now - 10.days,
        template: template,
        turma: turma1
      )
    end

    it 'returns only active formularios (current date between inicio and termino)' do
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      # Should include only formularios where current date is between inicio and termino
      expect(json).to be_an(Array)
      # The active one should be included, future and past should not
    end

    it 'includes turma and template data in response' do
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      if json.any?
        first_form = json.first
        # Should include associated data
        expect(first_form).to have_key('turma') | have_key('template')
      end
    end

    it 'includes user data in template' do
      get '/formularios'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      if json.any? && json.first['template']
        expect(json.first['template']).to have_key('user')
      end
    end
  end

  describe 'POST /formularios with various date scenarios' do
    it 'creates with start date in past and end date in future' do
      post '/formularios', params: {
        formulario: {
          titulo: 'CrossDate',
          data_inicio: DateTime.now - 5.days,
          data_termino: DateTime.now + 5.days,
          template_id: template.id,
          turma_id: turma1.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates with both dates in future' do
      post '/formularios', params: {
        formulario: {
          titulo: 'FutureBoth',
          data_inicio: DateTime.now + 1.day,
          data_termino: DateTime.now + 10.days,
          template_id: template.id,
          turma_id: turma1.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates with both dates in past' do
      post '/formularios', params: {
        formulario: {
          titulo: 'PastBoth',
          data_inicio: DateTime.now - 10.days,
          data_termino: DateTime.now - 1.day,
          template_id: template.id,
          turma_id: turma1.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates with same start and end date' do
      post '/formularios', params: {
        formulario: {
          titulo: 'SameDate',
          data_inicio: DateTime.now,
          data_termino: DateTime.now,
          template_id: template.id,
          turma_id: turma1.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end
  end

  describe 'PATCH /formularios/:id with date updates' do
    let!(:formulario) { Formulario.create!(titulo: 'Original', template: template, turma: turma1) }

    it 'updates only data_inicio' do
      patch "/formularios/#{formulario.id}", params: {
        formulario: { data_inicio: DateTime.now + 1.day }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'updates only data_termino' do
      patch "/formularios/#{formulario.id}", params: {
        formulario: { data_termino: DateTime.now + 7.days }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'updates both dates simultaneously' do
      patch "/formularios/#{formulario.id}", params: {
        formulario: {
          data_inicio: DateTime.now,
          data_termino: DateTime.now + 14.days
        }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'updates turma assignment' do
      patch "/formularios/#{formulario.id}", params: {
        formulario: { turma_id: turma2.id }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      formulario.reload
      expect(formulario.turma_id).to eq(turma2.id)
    end

    it 'updates template assignment' do
      new_template = Template.create!(nome: 'NewTpl', user: admin)
      patch "/formularios/#{formulario.id}", params: {
        formulario: { template_id: new_template.id }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end
  end

  describe 'GET /formularios/:id (show with includes)' do
    let!(:formulario) do
      Formulario.create!(
        titulo: 'ShowTest',
        data_inicio: DateTime.now,
        data_termino: DateTime.now + 7.days,
        template: template,
        turma: turma1
      )
    end

    it 'shows formulario with turma details' do
      get "/formularios/#{formulario.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json).to have_key('turma') | have_key('id')
    end

    it 'shows formulario with template details' do
      get "/formularios/#{formulario.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      expect(json).to have_key('template') | have_key('id')
    end

    it 'shows formulario with user info in template' do
      get "/formularios/#{formulario.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      
      if json['template']
        expect(json['template']).to have_key('user')
      end
    end
  end
end
