require 'rails_helper'

# Testes do controller de Questões
RSpec.describe QuestaosController, type: :request do
  let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
  let!(:template) { Template.create(nome: 'Template Teste', descricao: 'Descrição teste', user: user) }
  
  describe 'GET /questaos' do
    context 'quando tem questões cadastradas (Happy Path)' do
      let!(:questao1) { Questao.create(texto: 'Pergunta 1', tipo: 'texto', template: template, ordem: 1) }
      let!(:questao2) { Questao.create(texto: 'Pergunta 2', tipo: 'multipla_escolha', template: template, ordem: 2) }

      it 'retorna lista de todas as questões' do
        get '/questaos'
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.length).to eq(2)
        expect(json_response.first['texto']).to eq('Pergunta 1')
      end
    end

    context 'quando não tem questões (Sad Path)' do
      it 'retorna lista vazia' do
        get '/questaos'
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'GET /questaos/:id' do
    let!(:questao) { Questao.create(texto: 'Pergunta Teste', tipo: 'texto', template: template, ordem: 1) }

    context 'quando questão existe (Happy Path)' do
      it 'retorna a questão específica' do
        get "/questaos/#{questao.id}"
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['texto']).to eq('Pergunta Teste')
        expect(json_response['tipo']).to eq('texto')
      end
    end

    context 'quando questão não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/questaos/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /questaos' do
    context 'com dados válidos (Happy Path)' do
      let(:questao_params) do
        {
          questao: {
            texto: 'Nova Pergunta',
            tipo: 'multipla_escolha',
            obrigatoria: true,
            ordem: 1,
            opcoes: '["Opção 1", "Opção 2", "Opção 3"]',
            template_id: template.id
          }
        }
      end

      it 'cria questão com sucesso' do
        post '/questaos', params: questao_params
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['texto']).to eq('Nova Pergunta')
        expect(json_response['tipo']).to eq('multipla_escolha')
        expect(Questao.count).to eq(1)
      end
    end

    context 'com dados inválidos (Sad Path)' do
      let(:questao_params_invalidos) do
        {
          questao: {
            texto: '',
            tipo: '',
            template_id: nil
          }
        }
      end

      it 'retorna erro de validação' do
        post '/questaos', params: questao_params_invalidos
        expect(response).to have_http_status(:unprocessable_content)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('template')
      end
    end

    context 'com template inexistente (Sad Path)' do
      let(:questao_params_template_inexistente) do
        {
          questao: {
            texto: 'Pergunta com template inválido',
            tipo: 'texto',
            template_id: 999999
          }
        }
      end

      it 'retorna erro de validação' do
        post '/questaos', params: questao_params_template_inexistente
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT /questaos/:id' do
    let!(:questao) { Questao.create(texto: 'Pergunta Original', tipo: 'texto', template: template, ordem: 1) }

    context 'com dados válidos (Happy Path)' do
      let(:update_params) do
        {
          questao: {
            texto: 'Pergunta Atualizada',
            tipo: 'multipla_escolha'
          }
        }
      end

      it 'atualiza questão com sucesso' do
        put "/questaos/#{questao.id}", params: update_params
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['texto']).to eq('Pergunta Atualizada')
        expect(json_response['tipo']).to eq('multipla_escolha')
        
        questao.reload
        expect(questao.texto).to eq('Pergunta Atualizada')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      let(:update_params_invalidos) do
        {
          questao: {
            template_id: 999999
          }
        }
      end

      it 'retorna erro de validação' do
        put "/questaos/#{questao.id}", params: update_params_invalidos
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /questaos/:id' do
    let!(:questao) { Questao.create(texto: 'Pergunta para Deletar', tipo: 'texto', template: template, ordem: 1) }

    context 'quando questão existe (Happy Path)' do
      it 'deleta questão com sucesso' do
        expect {
          delete "/questaos/#{questao.id}"
        }.to change(Questao, :count).by(-1)
        
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando questão não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/questaos/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end