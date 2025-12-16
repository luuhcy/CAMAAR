require 'rails_helper'

RSpec.describe 'TemplatesController comprehensive coverage', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }
  let!(:user) { User.create!(nome: 'U', email: 'u@ex.com', matricula: 'UU', password: 'p', tipo: 'student') }

  describe 'creation' do
    it 'creates template with required fields' do
      post '/templates', params: {
        template: {
          nome: 'Template 1',
          user_id: admin.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates template with descricao' do
      post '/templates', params: {
        template: {
          nome: 'Template 2',
          descricao: 'A useful template',
          user_id: admin.id
        }
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails without nome' do
      post '/templates', params: {
        template: {
          user_id: admin.id
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails without user_id' do
      post '/templates', params: {
        template: {
          nome: 'Template'
        }
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'fails with invalid user_id' do
      post '/templates', params: {
        template: {
          nome: 'Template',
          user_id: 99999
        }
      }
      expect(response.status).to be_in([400, 422])
    end
  end

  describe 'listing' do
    let!(:tpl1) { Template.create!(nome: 'Tpl1', user: admin) }
    let!(:tpl2) { Template.create!(nome: 'Tpl2', user: user) }

    it 'lists all templates' do
      get '/templates'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.length).to be >= 2
    end

    it 'filters by user_id' do
      get "/templates?user_id=#{admin.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific template' do
      get "/templates/#{tpl1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['template']&.[]('id')).to eq(tpl1.id)
    end

    it 'returns 404 for nonexistent template' do
      get '/templates/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:tpl1) { Template.create!(nome: 'Original', user: admin) }

    it 'updates nome' do
      patch "/templates/#{tpl1.id}", params: {
        template: { nome: 'Updated' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      tpl1.reload
      expect(tpl1.nome).to eq('Updated')
    end

    it 'updates descricao' do
      patch "/templates/#{tpl1.id}", params: {
        template: { descricao: 'New description' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'fails to update with invalid user_id' do
      patch "/templates/#{tpl1.id}", params: {
        template: { user_id: 99999 }
      }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'deletion' do
    let!(:tpl1) { Template.create!(nome: 'ToDelete', user: admin) }

    it 'deletes template' do
      expect {
        delete "/templates/#{tpl1.id}"
      }.to change(Template, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent' do
      delete '/templates/99999'
      expect(response).to have_http_status(:not_found)
    end

    it 'cannot delete template with associated formularios due to FK constraint' do
      template = Template.create!(nome: 'WithFormularios', user: admin)
      turma = Turma.create!(codigo_sigaa: 'T1', nome: 'N', disciplina: 'D', semestre: '1/2025', ano: 2025)
      Formulario.create!(titulo: 'F', template: template, turma: turma)

      expect {
        delete "/templates/#{template.id}"
      }.to raise_error(ActiveRecord::InvalidForeignKey)
    end
  end
end
