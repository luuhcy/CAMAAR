require 'rails_helper'

# Testes do controller de Respostas
RSpec.describe RespostasController, type: :request do
  let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
  let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
  let!(:template) { Template.create(nome: 'Template Teste', descricao: 'Descrição teste', user: professor) }
  let!(:turma) { Turma.create(codigo_sigaa: 'CIC123', nome: 'Turma Teste', disciplina: 'Disciplina Teste', semestre: '2024.1') }
  let!(:formulario) do
    Formulario.create(
      titulo: 'Formulário Teste',
      data_inicio: 1.day.ago,
      data_termino: 1.day.from_now,
      template: template,
      turma: turma
    )
  end
  
  describe 'GET /respostas' do
    context 'quando tem respostas cadastradas (Happy Path)' do
      let!(:resposta1) do
        Respostum.create(
          data_resposta: { '1' => 'Resposta 1', '2' => 'Resposta 2' },
          status: 'enviado',
          user: user,
          formulario: formulario
        )
      end
      let!(:resposta2) do
        Respostum.create(
          data_resposta: { '1' => 'Outra resposta' },
          status: 'rascunho',
          user: user,
          formulario: formulario
        )
      end

      it 'retorna lista de todas as respostas' do
        get '/respostas'
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.length).to eq(2)
        expect(json_response.first['status']).to eq('enviado')
      end
    end

    context 'quando não tem respostas (Sad Path)' do
      it 'retorna lista vazia' do
        get '/respostas'
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'GET /respostas/:id' do
    let!(:resposta) do
      Respostum.create(
        data_resposta: { '1' => 'Resposta teste', '2' => 'Segunda resposta' },
        status: 'enviado',
        user: user,
        formulario: formulario
      )
    end

    context 'quando resposta existe (Happy Path)' do
      it 'retorna a resposta específica' do
        get "/respostas/#{resposta.id}"
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('enviado')
        expect(json_response['data_resposta']['1']).to eq('Resposta teste')
      end
    end

    context 'quando resposta não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/respostas/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /respostas' do
    context 'com dados válidos (Happy Path)' do
      let(:resposta_params) do
        {
          resposta: { '1' => 'Minha resposta', '2' => 'Segunda resposta' },
          user_id: user.id,
          formulario_id: formulario.id
        }
      end

      it 'cria resposta com sucesso' do
        post '/respostas', params: resposta_params
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('enviado')
        expect(json_response['data_resposta']['1']).to eq('Minha resposta')
        expect(Respostum.count).to eq(1)
      end
    end

    context 'com usuário inexistente (Sad Path)' do
      let(:resposta_params_user_inexistente) do
        {
          resposta: { '1' => 'Resposta' },
          user_id: 999999,
          formulario_id: formulario.id
        }
      end

      it 'retorna erro de validação' do
        post '/respostas', params: resposta_params_user_inexistente
expect(response).to have_http_status(:not_found)
      end
    end

    context 'com formulário inexistente (Sad Path)' do
      let(:resposta_params_formulario_inexistente) do
        {
          resposta: { '1' => 'Resposta' },
          user_id: user.id,
          formulario_id: 999999
        }
      end

      it 'retorna erro de validação' do
        post '/respostas', params: resposta_params_formulario_inexistente
        expect(response).to have_http_status(:unprocessable_entity)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('formulario')
      end
    end

    context 'sem dados de resposta (Sad Path)' do
      let(:resposta_params_sem_dados) do
        {
          resposta: nil,
          user_id: user.id,
          formulario_id: formulario.id
        }
      end

      it 'ainda cria resposta mas com dados vazios' do
        post '/respostas', params: resposta_params_sem_dados
        expect(response).to have_http_status(:created)
        
        json_response = JSON.parse(response.body)
        expect(json_response['data_resposta']).to be_nil
      end
    end
  end

  describe 'PUT /respostas/:id' do
    let!(:resposta) do
      Respostum.create(
        data_resposta: { '1' => 'Resposta original' },
        status: 'rascunho',
        user: user,
        formulario: formulario
      )
    end

    context 'com dados válidos (Happy Path)' do
      let(:update_params) do
        {
          respostum: {
            data_resposta: { '1' => 'Resposta atualizada', '2' => 'Nova resposta' },
            status: 'enviado'
          }
        }
      end

      it 'atualiza resposta com sucesso' do
        put "/respostas/#{resposta.id}", params: update_params
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('enviado')
expect(json_response['data_resposta']).to be_a(Hash)
        
        resposta.reload
        expect(resposta.status).to eq('enviado')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      let(:update_params_invalidos) do
        {
          respostum: {
            user_id: 999999
          }
        }
      end

      it 'retorna erro de validação' do
        put "/respostas/#{resposta.id}", params: update_params_invalidos
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /respostas/:id' do
    let!(:resposta) do
      Respostum.create(
        data_resposta: { '1' => 'Resposta para deletar' },
        status: 'enviado',
        user: user,
        formulario: formulario
      )
    end

    context 'quando resposta existe (Happy Path)' do
      it 'deleta resposta com sucesso' do
        expect {
          delete "/respostas/#{resposta.id}"
        }.to change(Respostum, :count).by(-1)
        
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando resposta não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/respostas/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end