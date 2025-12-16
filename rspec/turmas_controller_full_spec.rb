require 'rails_helper'

# Testes completos do controller de Turmas
RSpec.describe TurmasController, type: :request do
  describe 'GET /turmas' do
    context 'quando tem turmas (Happy Path)' do
      let!(:turma1) { Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma 1', disciplina: 'Disciplina 1', semestre: '2024.1') }
      let!(:turma2) { Turma.create!(codigo_sigaa: 'CIC002', nome: 'Turma 2', disciplina: 'Disciplina 2', semestre: '2024.1') }

      it 'lista todas as turmas' do
        get '/turmas'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(2)
      end
    end

    context 'quando não tem turmas (Sad Path)' do
      it 'retorna lista vazia' do
        get '/turmas'
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end
  end

  describe 'GET /turmas/:id' do
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma Teste', disciplina: 'Disciplina', semestre: '2024.1') }

    context 'quando turma existe (Happy Path)' do
      it 'retorna a turma específica' do
        get "/turmas/#{turma.id}"
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['turma']['codigo_sigaa']).to eq('CIC001')
      end
    end

    context 'quando turma não existe (Sad Path)' do
      it 'retorna erro 404' do
        get '/turmas/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /turmas' do
    context 'com dados válidos (Happy Path)' do
      let(:valid_attributes) { { codigo_sigaa: 'CIC003', nome: 'Nova Turma', disciplina: 'Nova Disciplina', semestre: '2024.2' } }

      it 'cria nova turma' do
        expect {
          post '/turmas', params: { turma: valid_attributes }
        }.to change(Turma, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'não cria turma sem código' do
        post '/turmas', params: { turma: { nome: 'Turma Sem Código', disciplina: 'Disciplina', semestre: '2024.1' } }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'não permite código duplicado no mesmo semestre' do
        Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma 1', disciplina: 'Disciplina', semestre: '2024.1')
        post '/turmas', params: { turma: { codigo_sigaa: 'CIC001', nome: 'Turma 2', disciplina: 'Disciplina', semestre: '2024.1' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT /turmas/:id' do
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma Original', disciplina: 'Disciplina', semestre: '2024.1') }

    context 'com dados válidos (Happy Path)' do
      it 'atualiza a turma' do
        put "/turmas/#{turma.id}", params: { turma: { nome: 'Turma Atualizada' } }
        expect(response).to have_http_status(:ok)
        turma.reload
        expect(turma.nome).to eq('Turma Atualizada')
      end
    end

    context 'com dados inválidos (Sad Path)' do
      it 'retorna erro de validação' do
        put "/turmas/#{turma.id}", params: { turma: { codigo_sigaa: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE /turmas/:id' do
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma para Deletar', disciplina: 'Disciplina', semestre: '2024.1') }

    context 'quando turma existe (Happy Path)' do
      it 'deleta a turma' do
        expect {
          delete "/turmas/#{turma.id}"
        }.to change(Turma, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'quando turma não existe (Sad Path)' do
      it 'retorna erro 404' do
        delete '/turmas/999999'
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end