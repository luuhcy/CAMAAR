require 'rails_helper'

# Testes de casos extremos e edge cases
RSpec.describe 'Edge Cases', type: :model do
  describe 'User edge cases' do
    context 'senhas e autenticação' do
      it 'aceita senhas de tamanho normal (Happy Path)' do
        user = User.new(
          nome: 'User Teste',
          email: 'test@example.com',
          password: 'senha123456',
          tipo: 'aluno',
          matricula: '123456'
        )
        expect(user).to be_valid
      end
      
      it 'aceita senhas com 6 caracteres (Happy Path)' do
        user = User.new(
          nome: 'User Teste',
          email: 'test2@example.com',
          password: '123456',
          tipo: 'aluno',
          matricula: '123457'
        )
        expect(user).to be_valid
      end
    end
    
    context 'emails especiais' do
      it 'aceita emails com caracteres especiais (Happy Path)' do
        user = User.new(
          nome: 'User Teste',
          email: 'test+tag@sub.domain.com',
          password: '123456',
          tipo: 'aluno',
          matricula: '123456'
        )
        expect(user).to be_valid
      end
    end
  end
  
  describe 'Template edge cases' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    
    context 'nomes extremos' do
      it 'aceita nome muito longo (Happy Path)' do
        template = Template.new(
          nome: 'Template com nome muito longo ' * 10,
          user: user
        )
        expect(template).to be_valid
      end
      
      it 'aceita caracteres especiais no nome (Happy Path)' do
        template = Template.new(
          nome: 'Template com @#$%^&*()_+ caracteres',
          user: user
        )
        expect(template).to be_valid
      end
    end
  end
  
  describe 'Formulario edge cases' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    context 'datas extremas' do
      it 'aceita formulário com data muito no futuro (Happy Path)' do
        formulario = Formulario.new(
          titulo: 'Formulário Futuro',
          data_inicio: 1.year.from_now,
          data_termino: 2.years.from_now,
          template: template,
          turma: turma
        )
        expect(formulario).to be_valid
      end
      
      it 'aceita formulário com data no passado (Happy Path)' do
        formulario = Formulario.new(
          titulo: 'Formulário Passado',
          data_inicio: 2.years.ago,
          data_termino: 1.year.ago,
          template: template,
          turma: turma
        )
        expect(formulario).to be_valid
      end
    end
  end
  
  describe 'Respostum edge cases' do
    let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    
    context 'dados de resposta complexos' do
      it 'aceita dados JSON complexos (Happy Path)' do
        dados_complexos = {
          '1' => 'Resposta simples',
          '2' => ['opção1', 'opção2', 'opção3'],
          '3' => {
            'sub1' => 'valor1',
            'sub2' => ['array', 'dentro', 'de', 'objeto']
          },
          '4' => 'Resposta com caracteres especiais: @#$%^&*()'
        }
        
        resposta = Respostum.new(
          data_resposta: dados_complexos,
          status: 'enviado',
          user: user,
          formulario: formulario
        )
        expect(resposta).to be_valid
      end
      
      it 'aceita dados vazios (Happy Path)' do
        resposta = Respostum.new(
          data_resposta: {},
          status: 'rascunho',
          user: user,
          formulario: formulario
        )
        expect(resposta).to be_valid
      end
    end
  end
end