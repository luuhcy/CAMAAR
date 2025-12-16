require 'rails_helper'

RSpec.describe FormulariosController, type: :controller do
  let(:turma) { Turma.create!(codigo_sigaa: 'TST001', nome: 'Turma Teste', disciplina: 'Disciplina Teste', semestre: '1/2025', ano: 2025) }
  let(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '123456', password: 'password', tipo: 'admin') }
  let(:template) { Template.create!(nome: 'Template Teste', descricao: 'Descrição', user: user) }
  
  let(:valid_attributes) do
    {
      titulo: 'Formulário Teste',
      data_inicio: DateTime.now,
      data_termino: DateTime.now + 7.days,
      template_id: template.id,
      turma_id: turma.id
    }
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns formularios as JSON' do
      Formulario.create!(valid_attributes)
      get :index
      expect(response.content_type).to include('application/json')
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      formulario = Formulario.create!(valid_attributes)
      get :show, params: { id: formulario.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Formulario' do
        expect {
          post :create, params: { formulario: valid_attributes }
        }.to change(Formulario, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: { formulario: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Formulario' do
        expect {
          post :create, params: { formulario: { titulo: nil } }
        }.to change(Formulario, :count).by(0)
      end
    end
  end

  describe 'PATCH #update' do
    let(:formulario) { Formulario.create!(valid_attributes) }
    
    context 'with valid parameters' do
      it 'updates the formulario' do
        patch :update, params: { id: formulario.id, formulario: { titulo: 'Novo Título' } }
        formulario.reload
        expect(formulario.titulo).to eq('Novo Título')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested formulario' do
      formulario = Formulario.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: formulario.id }
      }.to change(Formulario, :count).by(-1)
    end
  end
end
