require 'rails_helper'

RSpec.describe 'RespostasController comprehensive coverage', type: :request do
  let!(:admin) { User.create!(nome: 'A', email: 'a@ex.com', matricula: 'AA', password: 'p', tipo: 'admin') }
  let!(:student_user) { User.create!(nome: 'S', email: 's@ex.com', matricula: 'SS', password: 'p', tipo: 'student') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'T1', nome: 'N', disciplina: 'D', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Tpl', descricao: 'D', user: admin) }
  let!(:formulario) { Formulario.create!(titulo: 'Form', template: template, turma: turma) }

  describe 'creation' do
    it 'creates resposta with minimal fields' do
      post '/respostas', params: {
        resposta: '{"q1":"answer"}',
        user_id: student_user.id,
        formulario_id: formulario.id
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'creates resposta successfully' do
      post '/respostas', params: {
        resposta: '{"q1":"answer","q2":"another"}',
        user_id: student_user.id,
        formulario_id: formulario.id
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails without user_id' do
      post '/respostas', params: {
        resposta: '{"q1":"answer"}',
        formulario_id: formulario.id
      }
      expect(response.status).to satisfy { |s| [400, 404, 422].include?(s) }
    end

    it 'fails without formulario_id' do
      post '/respostas', params: {
        resposta: '{"q1":"answer"}',
        user_id: student_user.id
      }
      expect(response.status).to be_in([400, 422])
    end

    it 'creates without explicit resposta data' do
      post '/respostas', params: {
        user_id: student_user.id,
        formulario_id: formulario.id
      }
      expect(response.status).to satisfy { |s| [200, 201].include?(s) }
    end

    it 'fails with invalid user_id' do
      post '/respostas', params: {
        resposta: '{"q1":"answer"}',
        user_id: 99999,
        formulario_id: formulario.id
      }
      expect(response.status).to satisfy { |s| [400, 404, 422].include?(s) }
    end

    it 'fails with invalid formulario_id' do
      post '/respostas', params: {
        resposta: '{"q1":"answer"}',
        user_id: student_user.id,
        formulario_id: 99999
      }
      expect(response.status).to be_in([400, 422])
    end
  end

  describe 'listing' do
    let!(:r1) { Respostum.create!(user: student_user, formulario: formulario, data_resposta: '{"q":"a"}') }

    it 'lists all respostas' do
      get '/respostas'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
    end

    it 'shows specific resposta' do
      get "/respostas/#{r1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id'] || json['respostum']&.[]('id')).to eq(r1.id)
    end

    it 'returns 404 for nonexistent resposta' do
      get '/respostas/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'updating' do
    let!(:r1) { Respostum.create!(user: student_user, formulario: formulario, data_resposta: '{"q":"a"}') }

    it 'updates data_resposta' do
      patch "/respostas/#{r1.id}", params: {
        respostum: { data_resposta: '{"q":"b"}' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
      r1.reload
      expect(r1.data_resposta).to eq('{"q":"b"}')
    end

    it 'updates status' do
      patch "/respostas/#{r1.id}", params: {
        respostum: { status: 'submitted' }
      }
      expect(response.status).to satisfy { |s| [200, 204].include?(s) }
    end

    it 'fails to update with invalid formulario_id' do
      patch "/respostas/#{r1.id}", params: {
        respostum: { formulario_id: 99999 }
      }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end

    it 'fails to update with invalid user_id' do
      patch "/respostas/#{r1.id}", params: {
        respostum: { user_id: 99999 }
      }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'deletion' do
    let!(:r1) { Respostum.create!(user: student_user, formulario: formulario, data_resposta: '{"q":"a"}') }

    it 'deletes resposta' do
      expect {
        delete "/respostas/#{r1.id}"
      }.to change(Respostum, :count).by(-1)
      expect(response.status).to satisfy { |s| [200, 204, 205].include?(s) }
    end

    it 'returns 404 when deleting nonexistent' do
      delete '/respostas/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
