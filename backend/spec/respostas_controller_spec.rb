require 'rails_helper'

RSpec.describe RespostasController, type: :controller do
  let(:turma) { Turma.create!(codigo_sigaa: 'TST001', nome: 'Turma Teste', disciplina: 'Disciplina Teste', semestre: '1/2025', ano: 2025) }
  let(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', matricula: '789012', password: 'password', tipo: 'estudante') }
  let(:template) { Template.create!(nome: 'Template Teste', descricao: 'Descrição', user: user) }
  let(:formulario) { Formulario.create!(titulo: 'Form Teste', data_inicio: DateTime.now, data_termino: DateTime.now + 7.days, template: template, turma: turma) }
  
  let(:valid_attributes) do
    {
      resposta: '{"0":"Resposta 1","1":"Resposta 2"}',
      user_id: user.id,
      formulario_id: formulario.id
    }
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns respostas as JSON' do
      Respostum.create!(
        data_resposta: '{"0":"Teste"}',
        status: 'enviado',
        user: user,
        formulario: formulario
      )
      get :index
      expect(response.content_type).to include('application/json')
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      resposta = Respostum.create!(
        data_resposta: '{"0":"Teste"}',
        status: 'enviado',
        user: user,
        formulario: formulario
      )
      get :show, params: { id: resposta.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Respostum' do
        expect {
          post :create, params: valid_attributes
        }.to change(Respostum, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it 'sets the status to enviado' do
        post :create, params: valid_attributes
        expect(Respostum.last.status).to eq('enviado')
      end
    end
  end

  describe 'PATCH #update' do
    let(:resposta) { Respostum.create!(data_resposta: '{"0":"Teste"}', status: 'enviado', user: user, formulario: formulario) }
    
    it 'updates the resposta' do
      patch :update, params: { id: resposta.id, respostum: { status: 'revisado' } }
      resposta.reload
      expect(resposta.status).to eq('revisado')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested resposta' do
      resposta = Respostum.create!(data_resposta: '{"0":"Teste"}', status: 'enviado', user: user, formulario: formulario)
      expect {
        delete :destroy, params: { id: resposta.id }
      }.to change(Respostum, :count).by(-1)
    end
  end
end
