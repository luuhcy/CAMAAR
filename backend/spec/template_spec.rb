require 'rails_helper'

# Testes do model Template
RSpec.describe Template, type: :model do
  let(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '123456', password: 'password', tipo: 'admin') }
  
  # Associações
  it { should belong_to(:user) }
  it { should have_many(:formularios) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      template = Template.new(nome: 'Template Teste', descricao: 'Descrição', user: user)
      expect(template).to be_valid
    end
    
    it 'is invalid without a nome' do
      template = Template.new(nome: nil, descricao: 'Desc', user: user)
      expect(template).to_not be_valid
    end
    
    it 'is invalid without a user' do
      template = Template.new(nome: 'Test', descricao: 'Desc', user: nil)
      expect(template).to_not be_valid
    end
  end
  
  describe 'associations' do
    it 'belongs to a user' do
      template = Template.create!(nome: 'Template 1', descricao: 'Desc', user: user)
      expect(template.user).to eq(user)
    end
    
    it 'can have multiple questoes' do
      template = Template.create!(nome: 'Template 2', descricao: 'Desc', user: user)
      q1 = Questao.create!(texto: 'Pergunta 1', tipo: 'objetiva', template: template)
      q2 = Questao.create!(texto: 'Pergunta 2', tipo: 'discursiva', template: template)
      
      expect(template.questaos.count).to eq(2)
      expect(template.questaos).to include(q1, q2)
    end
    
    it 'can have multiple formularios' do
      template = Template.create!(nome: 'Template 3', descricao: 'Desc', user: user)
      turma = Turma.create!(codigo_sigaa: 'TST001', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      
      form1 = Formulario.create!(titulo: 'Form 1', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma)
      form2 = Formulario.create!(titulo: 'Form 2', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma)
      
      expect(template.formularios.count).to eq(2)
    end
  end
end
