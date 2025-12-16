require 'rails_helper'

# Testes do controller de Formulários
RSpec.describe FormulariosController, type: :request do
  let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
  let!(:template) { Template.create(nome: 'Template Teste', descricao: 'Descrição teste', user: user) }
  let!(:turma) { Turma.create(codigo_sigaa: 'CIC123', nome: 'Turma Teste', disciplina: 'Disciplina Teste', semestre: '2024.1') }
  
  describe 'GET /formularios' do
    context 'quando tem formulários ativos (Happy Path)' do
      let!(:formulario_ativo) do
        Formulario.create(
          titulo: 'Formulário Ativo',
          data_inicio: 1.day.ago,
          data_termino: 1.day.from_now,
          template: template,
          turma: turma
        )
      end

      it 'retorna lista de formulários ativos' do
        get '/formularios'
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.first['titulo']).to eq('Formulário Ativo')
        expect(json_response.first['turma']['codigo_sigaa']).to eq('CIC123')
      end
    end

    context 'quando não tem formulários ativos (Sad Path)' do
      let!(:formulario_expirado) do
        Formulario.create(
          titulo: 'Formulário Expirado',
          data_inicio: 3.days.ago,
          data_termino: 1.day.ago,
          template: template,
          turma: turma
        )
      end

      it 'retorna lista vazia' do
        get '/formularios'
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'GET /formularios/:id' do
    let!(:formulario) do
      Formulario.create(
        titulo: 'Formulário Teste',
        data_inicio: 1.day.ago,
        data_termino: 1.day.from_now,
        template: template,
        turma: turma
      )
    end

    context 'quando formulário existe (Happy Path)' do
      it 'retorna o formulário específico' do
        get "/formularios/#{formulario.id}"
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['titulo']).to eq('Formulário Teste')
        expect(json_response['template']['nome']).to eq('Template Teste')
      end
    end

    context 'quando formulário não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/formularios/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /formularios' do
    context 'com dados válidos (Happy Path)' do
      let(:formulario_params) do
        {
          formulario: {
            titulo: 'Novo Formulário',
            data_inicio: 1.day.from_now,
            data_termino: 7.days.from_now,
            template_id: template.id,
            turma_id: turma.id
          }
        }
      end

      it 'cria formulário com sucesso' do
        post '/formularios', params: formulario_params
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['titulo']).to eq('Novo Formulário')
        expect(Formulario.count).to eq(1)
      end
    end

    context 'com dados inválidos (Sad Path)' do
      let(:formulario_params_invalidos) do
        {
          formulario: {
            titulo: '',
            data_inicio: nil,
            data_termino: nil,
            template_id: nil,
            turma_id: nil
          }
        }
      end

      it 'retorna erro de validação' do
        post '/formularios', params: formulario_params_invalidos
        expect(response).to have_http_status(:unprocessable_content)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('template')
        expect(json_response).to have_key('turma')
      end
    end
  end

  describe 'PUT /formularios/:id' do
    let!(:formulario) do
      Formulario.create(
        titulo: 'Formulário Original',
        data_inicio: 1.day.ago,
        data_termino: 1.day.from_now,
        template: template,
        turma: turma
      )
    end

    context 'com dados válidos (Happy Path)' do
      let(:update_params) do
        {
          formulario: {
            titulo: 'Formulário Atualizado'
          }
        }
      end

      it 'atualiza formulário com sucesso' do
        put "/formularios/#{formulario.id}", params: update_params
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['titulo']).to eq('Formulário Atualizado')
        
        formulario.reload
        expect(formulario.titulo).to eq('Formulário Atualizado')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      let(:update_params_invalidos) do
        {
          formulario: {
            template_id: 999999
          }
        }
      end

      it 'retorna erro de validação' do
        put "/formularios/#{formulario.id}", params: update_params_invalidos
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /formularios/:id' do
    let!(:formulario) do
      Formulario.create(
        titulo: 'Formulário para Deletar',
        data_inicio: 1.day.ago,
        data_termino: 1.day.from_now,
        template: template,
        turma: turma
      )
    end

    context 'quando formulário existe (Happy Path)' do
      it 'deleta formulário com sucesso' do
        expect {
          delete "/formularios/#{formulario.id}"
        }.to change(Formulario, :count).by(-1)
        
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando formulário não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/formularios/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end