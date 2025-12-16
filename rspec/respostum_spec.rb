require 'rails_helper'

# Testes do model Respostum
RSpec.describe Respostum, type: :model do
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
  
  # Testa as associações
  it { should belong_to(:user) }
  it { should belong_to(:formulario) }

  describe 'criação de resposta' do
    context 'com dados válidos (Happy Path)' do
      it 'cria resposta com dados JSON' do
        resposta = Respostum.new(
          data_resposta: { '1' => 'Resposta para pergunta 1', '2' => 'Resposta para pergunta 2' },
          status: 'enviado',
          user: user,
          formulario: formulario
        )
        
        expect(resposta).to be_valid
        expect(resposta.save).to be true
        expect(resposta.data_resposta['1']).to eq('Resposta para pergunta 1')
        expect(resposta.status).to eq('enviado')
      end

      it 'cria resposta com status rascunho' do
        resposta = Respostum.create(
          data_resposta: { '1' => 'Rascunho de resposta' },
          status: 'rascunho',
          user: user,
          formulario: formulario
        )
        
        expect(resposta).to be_valid
        expect(resposta.status).to eq('rascunho')
      end
    end

    context 'sem usuário (Sad Path)' do
      it 'não cria resposta sem usuário' do
        resposta = Respostum.new(
          data_resposta: { '1' => 'Resposta sem usuário' },
          status: 'enviado',
          formulario: formulario
        )
        
        expect(resposta).not_to be_valid
        expect(resposta.errors[:user]).to include("must exist")
      end
    end

    context 'sem formulário (Sad Path)' do
      it 'não cria resposta sem formulário' do
        resposta = Respostum.new(
          data_resposta: { '1' => 'Resposta sem formulário' },
          status: 'enviado',
          user: user
        )
        
        expect(resposta).not_to be_valid
        expect(resposta.errors[:formulario]).to include("must exist")
      end
    end
  end

  describe 'serialização de dados' do
    it 'converte dados JSON automaticamente (Happy Path)' do
      dados_resposta = {
        '1' => 'Primeira resposta',
        '2' => 'Segunda resposta',
        '3' => ['opção1', 'opção2']
      }
      
      resposta = Respostum.create(
        data_resposta: dados_resposta,
        status: 'enviado',
        user: user,
        formulario: formulario
      )
      
      resposta.reload
      expect(resposta.data_resposta).to eq(dados_resposta)
      expect(resposta.data_resposta['3']).to be_an(Array)
    end

    it 'aceita dados vazios (Sad Path que é válido)' do
      resposta = Respostum.create(
        data_resposta: nil,
        status: 'rascunho',
        user: user,
        formulario: formulario
      )
      
      expect(resposta).to be_valid
      expect(resposta.data_resposta).to be_nil
    end
  end

  describe 'status da resposta' do
    it 'aceita diferentes status (Happy Path)' do
      status_validos = ['rascunho', 'enviado', 'revisado']
      
      status_validos.each do |status|
        resposta = Respostum.create(
          data_resposta: { '1' => "Resposta com status #{status}" },
          status: status,
          user: user,
          formulario: formulario
        )
        
        expect(resposta).to be_valid
        expect(resposta.status).to eq(status)
      end
    end
  end
end
