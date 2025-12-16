require 'rails_helper'

# Testes do model Questao
RSpec.describe Questao, type: :model do
  let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
  let!(:template) { Template.create(nome: 'Template Teste', descricao: 'Descrição teste', user: user) }
  
  # Testa as associações
  it { should belong_to(:template) }

  describe 'criação de questão' do
    context 'com dados válidos (Happy Path)' do
      it 'cria questão de texto com sucesso' do
        questao = Questao.new(
          texto: 'Qual sua opinião sobre a disciplina?',
          tipo: 'texto',
          obrigatoria: true,
          ordem: 1,
          template: template
        )
        
        expect(questao).to be_valid
        expect(questao.save).to be true
        expect(questao.texto).to eq('Qual sua opinião sobre a disciplina?')
        expect(questao.tipo).to eq('texto')
      end

      it 'cria questão de múltipla escolha com opções' do
        questao = Questao.new(
          texto: 'Como você avalia a disciplina?',
          tipo: 'multipla_escolha',
          obrigatoria: false,
          ordem: 2,
          opcoes: '["Excelente", "Bom", "Regular", "Ruim"]',
          template: template
        )
        
        expect(questao).to be_valid
        expect(questao.save).to be true
        expect(questao.opcoes).to eq('["Excelente", "Bom", "Regular", "Ruim"]')
      end
    end

    context 'sem template (Sad Path)' do
      it 'não cria questão sem template' do
        questao = Questao.new(
          texto: 'Questão sem template',
          tipo: 'texto',
          ordem: 1
        )
        
        expect(questao).not_to be_valid
        expect(questao.errors[:template]).to include("must exist")
      end
    end

    context 'com dados vazios (Sad Path)' do
      it 'não aceita questão com texto vazio' do
        questao = Questao.new(
          texto: '',
          tipo: 'texto',
          template: template
        )
        
        # Agora tem validação para texto obrigatório
        expect(questao).not_to be_valid
        expect(questao.errors[:texto]).to include("can't be blank")
      end
    end
  end

  describe 'tipos de questão' do
    it 'aceita diferentes tipos de questão (Happy Path)' do
      tipos = ['texto', 'multipla_escolha', 'escala', 'sim_nao']
      
      tipos.each do |tipo|
        questao = Questao.create(
          texto: "Questão do tipo #{tipo}",
          tipo: tipo,
          template: template,
          ordem: 1
        )
        
        expect(questao).to be_valid
        expect(questao.tipo).to eq(tipo)
      end
    end
  end

  describe 'ordenação' do
    it 'permite questões com diferentes ordens (Happy Path)' do
      questao1 = Questao.create(texto: 'Primeira', tipo: 'texto', ordem: 1, template: template)
      questao2 = Questao.create(texto: 'Segunda', tipo: 'texto', ordem: 2, template: template)
      questao3 = Questao.create(texto: 'Terceira', tipo: 'texto', ordem: 3, template: template)
      
      expect(questao1.ordem).to eq(1)
      expect(questao2.ordem).to eq(2)
      expect(questao3.ordem).to eq(3)
    end
  end
end
