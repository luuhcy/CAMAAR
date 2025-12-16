require 'rails_helper'

# Testes do controller de Templates
RSpec.describe TemplatesController, type: :request do
  let!(:user) { User.create!(nome: 'Professor', email: 'test@example.com', password: 'password123', tipo: 'professor', matricula: '123456') }
  let(:valid_attributes) { { nome: 'Template Test', descricao: 'Description', user_id: user.id } }

  describe 'GET /templates' do
    context 'quando tem templates (Happy Path)' do
      let!(:template1) { Template.create!(nome: 'Template 1', descricao: 'Desc 1', user: user) }
      let!(:template2) { Template.create!(nome: 'Template 2', descricao: 'Desc 2', user: user) }

      it 'lista todos os templates' do
        get '/templates'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end
    end

    context 'quando não tem templates (Sad Path)' do
      it 'retorna lista vazia' do
        get '/templates'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'GET /templates/:id' do
    let!(:template) { Template.create!(nome: 'Template Teste', descricao: 'Descrição', user: user) }

    context 'quando template existe (Happy Path)' do
      it 'retorna o template específico' do
        get "/templates/#{template.id}"
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['nome']).to eq('Template Teste')
      end
    end

    context 'quando template não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/templates/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /templates' do
    context 'com dados válidos (Happy Path)' do
      it 'cria um novo template' do
        expect {
          post '/templates', params: { template: valid_attributes }
        }.to change(Template, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        post '/templates', params: { template: { nome: '', user_id: user.id } }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'retorna erro sem usuário' do
        post '/templates', params: { template: { nome: 'Template Sem User' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT /templates/:id' do
    let!(:template) { Template.create!(nome: 'Template Original', descricao: 'Desc Original', user: user) }

    context 'com dados válidos (Happy Path)' do
      it 'atualiza o template' do
        put "/templates/#{template.id}", params: { template: { nome: 'Template Atualizado' } }
        expect(response).to have_http_status(:ok)
        template.reload
        expect(template.nome).to eq('Template Atualizado')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        put "/templates/#{template.id}", params: { template: { nome: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /templates/:id' do
    let!(:template) { Template.create!(nome: 'Template para Deletar', user: user) }

    context 'quando template existe (Happy Path)' do
      it 'deleta o template' do
        expect {
          delete "/templates/#{template.id}"
        }.to change(Template, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando template não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/templates/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
