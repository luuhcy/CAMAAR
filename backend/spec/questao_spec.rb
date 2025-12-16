require 'rails_helper'

# Testes do model Questao
RSpec.describe Questao, type: :model do
  let(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '123456', password: 'password', tipo: 'admin') }
  let(:template) { Template.create!(nome: 'Template', descricao: 'Desc', user: user) }
  
  # Associações
  it { should belong_to(:template) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      questao = Questao.new(texto: 'Qual sua avaliação?', tipo: 'objetiva', template: template)
      expect(questao).to be_valid
    end
    
    it 'is invalid without a texto' do
      questao = Questao.new(texto: nil, tipo: 'objetiva', template: template)
      expect(questao).to_not be_valid
    end
    
    it 'is invalid without a tipo' do
      questao = Questao.new(texto: 'Pergunta', tipo: nil, template: template)
      expect(questao).to_not be_valid
    end
    
    it 'is invalid without a template' do
      questao = Questao.new(texto: 'Pergunta', tipo: 'objetiva', template: nil)
      expect(questao).to_not be_valid
    end
  end
  
  describe 'tipos de questao' do
    it 'can be objetiva' do
      questao = Questao.create!(texto: 'Objetiva', tipo: 'objetiva', template: template)
      expect(questao.tipo).to eq('objetiva')
    end
    
    it 'can be discursiva' do
      questao = Questao.create!(texto: 'Discursiva', tipo: 'discursiva', template: template)
      expect(questao.tipo).to eq('discursiva')
    end
  end
  
  describe 'associations' do
    it 'belongs to a template' do
      questao = Questao.create!(texto: 'Test', tipo: 'objetiva', template: template)
      expect(questao.template).to eq(template)
    end
    
    it 'template can have multiple questoes' do
      q1 = Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
      q2 = Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template)
      
      expect(template.questaos).to include(q1, q2)
    end
  end
end
