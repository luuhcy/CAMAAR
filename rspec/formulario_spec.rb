require 'rails_helper'

# Testes do model Formulario
RSpec.describe Formulario, type: :model do
  let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
  let!(:template) { Template.create(nome: 'Template Teste', descricao: 'Descrição teste', user: user) }
  let!(:turma) { Turma.create(codigo_sigaa: 'CIC123', nome: 'Turma Teste', disciplina: 'Disciplina Teste', semestre: '2024.1') }
  
  # Testa as associações
  it { should belong_to(:template) }
  it { should belong_to(:turma) }
  it { should have_many(:respostas).class_name('Respostum').with_foreign_key('formulario_id').dependent(:destroy) }

  describe 'criação de formulário' do
    context 'com dados válidos (Happy Path)' do
      it 'cria formulário com sucesso' do
        formulario = Formulario.new(
          titulo: 'Formulário Teste',
          data_inicio: 1.day.ago,
          data_termino: 1.day.from_now,
          template: template,
          turma: turma
        )
        
        expect(formulario).to be_valid
        expect(formulario.save).to be true
        expect(formulario.titulo).to eq('Formulário Teste')
      end
    end

    context 'sem template (Sad Path)' do
      it 'não cria formulário sem template' do
        formulario = Formulario.new(
          titulo: 'Formulário Sem Template',
          data_inicio: 1.day.ago,
          data_termino: 1.day.from_now,
          turma: turma
        )
        
        expect(formulario).not_to be_valid
        expect(formulario.errors[:template]).to include("must exist")
      end
    end

    context 'sem turma (Sad Path)' do
      it 'não cria formulário sem turma' do
        formulario = Formulario.new(
          titulo: 'Formulário Sem Turma',
          data_inicio: 1.day.ago,
          data_termino: 1.day.from_now,
          template: template
        )
        
        expect(formulario).not_to be_valid
        expect(formulario.errors[:turma]).to include("must exist")
      end
    end
  end

  describe 'exclusão em cascata' do
    it 'deleta respostas quando formulário é deletado (Happy Path)' do
      formulario = Formulario.create(
        titulo: 'Formulário com Respostas',
        data_inicio: 1.day.ago,
        data_termino: 1.day.from_now,
        template: template,
        turma: turma
      )
      
      aluno = User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '222222')
      resposta = Respostum.create(
        data_resposta: { '1' => 'Resposta teste' },
        status: 'enviado',
        user: aluno,
        formulario: formulario
      )
      
      expect { formulario.destroy }.to change(Respostum, :count).by(-1)
    end
  end
end
