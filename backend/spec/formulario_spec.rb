require 'rails_helper'

# Testes do model Formulario
RSpec.describe Formulario, type: :model do
  let(:turma) { Turma.create!(codigo_sigaa: 'TST001', nome: 'Turma Teste', disciplina: 'Teste', semestre: '1/2025', ano: 2025) }
  let(:user) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '123456', password: 'password', tipo: 'admin') }
  let(:template) { Template.create!(nome: 'Template Teste', descricao: 'Desc', user: user) }
  
  # Verifica as associações
  it { should belong_to(:template) }
  it { should belong_to(:turma) }
  
  describe 'validations' do
    it 'is valid with valid attributes' do
      formulario = Formulario.new(
        titulo: 'Teste',
        data_inicio: DateTime.now,
        data_termino: DateTime.now + 1.day,
        template: template,
        turma: turma
      )
      expect(formulario).to be_valid
    end
    
    it 'is invalid without a titulo' do
      formulario = Formulario.new(titulo: nil)
      expect(formulario).to_not be_valid
    end
  end
  
  describe 'date range' do
    it 'can have formularios with different date ranges' do
      form1 = Formulario.create!(titulo: 'F1', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma)
      form2 = Formulario.create!(titulo: 'F2', data_inicio: DateTime.now + 2.days, data_termino: DateTime.now + 3.days, template: template, turma: turma)
      
      expect(form1).to be_persisted
      expect(form2).to be_persisted
    end
  end
end
