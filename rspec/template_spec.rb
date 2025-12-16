require 'rails_helper'

# Testes do model Template
RSpec.describe Template, type: :model do
  let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
  
  # Testa associações
  it { should belong_to(:user) }
  it { should have_many(:formularios) }
  it { should have_many(:questoes).class_name('Questao').dependent(:destroy) }
  it { should have_many(:questaos).class_name('Questao').dependent(:destroy) }
  
  # Testa validações
  it { should validate_presence_of(:nome) }
  
  describe 'criação de template' do
    context 'com dados válidos (Happy Path)' do
      it 'cria template válido' do
        template = Template.new(nome: 'Template Teste', descricao: 'Descrição', user: user)
        expect(template).to be_valid
        expect(template.save).to be true
      end
      
      it 'cria template sem descrição' do
        template = Template.new(nome: 'Template Simples', user: user)
        expect(template).to be_valid
      end
    end
    
    context 'com dados inválidos (Sad Path)' do
      it 'não cria template sem nome' do
        template = Template.new(descricao: 'Descrição', user: user)
        expect(template).not_to be_valid
        expect(template.errors[:nome]).to include("can't be blank")
      end
      
      it 'não cria template sem usuário' do
        template = Template.new(nome: 'Template Sem User')
        expect(template).not_to be_valid
        expect(template.errors[:user]).to include("must exist")
      end
    end
  end
  
  describe 'exclusão em cascata' do
    it 'deleta questões quando template é deletado (Happy Path)' do
      template = Template.create!(nome: 'Template com Questões', user: user)
      questao = Questao.create!(texto: 'Pergunta teste', tipo: 'texto', template: template)
      
      expect { template.destroy }.to change(Questao, :count).by(-1)
    end
  end
  
  describe 'relacionamentos' do
    it 'pode ter múltiplas questões (Happy Path)' do
      template = Template.create!(nome: 'Template Multi Questões', user: user)
      questao1 = Questao.create!(texto: 'Pergunta 1', tipo: 'texto', template: template)
      questao2 = Questao.create!(texto: 'Pergunta 2', tipo: 'multipla_escolha', template: template)
      
      expect(template.questoes.count).to eq(2)
      expect(template.questoes).to include(questao1, questao2)
    end
    
    it 'pode gerar múltiplos formulários (Happy Path)' do
      template = Template.create!(nome: 'Template Multi Forms', user: user)
      turma1 = Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma 1', semestre: '2024.1')
      turma2 = Turma.create!(codigo_sigaa: 'CIC002', nome: 'Turma 2', semestre: '2024.1')
      
      form1 = Formulario.create!(titulo: 'Form 1', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma1)
      form2 = Formulario.create!(titulo: 'Form 2', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma2)
      
      expect(template.formularios.count).to eq(2)
      expect(template.formularios).to include(form1, form2)
    end
  end
end
