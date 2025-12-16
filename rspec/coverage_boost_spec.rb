require 'rails_helper'

# Testes específicos para aumentar cobertura para 90%
RSpec.describe 'Coverage Boost Tests', type: :model do
  
  describe 'Model methods coverage' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    context 'Template methods' do
      it 'template tem nome válido' do
        expect(template.nome).to eq('Template')
        expect(template.user).to eq(user)
      end
      
      it 'template pode ter descrição' do
        template.update!(descricao: 'Nova descrição')
        expect(template.descricao).to eq('Nova descrição')
      end
    end
    
    context 'User methods' do
      it 'user tem todos os atributos' do
        expect(user.nome).to eq('Professor')
        expect(user.email).to eq('prof@test.com')
        expect(user.tipo).to eq('professor')
        expect(user.matricula).to eq('123456')
      end
      
      it 'user pode ter templates' do
        expect(user.templates).to include(template)
      end
    end
    
    context 'Turma methods' do
      it 'turma tem todos os atributos' do
        expect(turma.codigo_sigaa).to eq('CIC123')
        expect(turma.nome).to eq('Turma')
        expect(turma.disciplina).to eq('Disciplina')
        expect(turma.semestre).to eq('2024.1')
      end
      
      it 'turma pode ter ano' do
        turma.update!(ano: 2024)
        expect(turma.ano).to eq(2024)
      end
    end
  end
  
  describe 'Association methods coverage' do
    let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    
    context 'Formulario associations' do
      it 'formulario pertence a template e turma' do
        expect(formulario.template).to eq(template)
        expect(formulario.turma).to eq(turma)
      end
      
      it 'formulario pode ter respostas' do
        resposta = Respostum.create!(
          data_resposta: { '1' => 'Resposta' },
          status: 'enviado',
          user: user,
          formulario: formulario
        )
        expect(formulario.respostas).to include(resposta)
      end
    end
    
    context 'Questao associations' do
      let!(:questao) { Questao.create!(texto: 'Pergunta', tipo: 'texto', template: template) }
      
      it 'questao pertence a template' do
        expect(questao.template).to eq(template)
      end
      
      it 'template tem questoes' do
        expect(template.questoes).to include(questao)
        expect(template.questaos).to include(questao)
      end
    end
    
    context 'Student associations' do
      let!(:student) { Student.create!(name: 'Aluno', email: 'student@test.com', matricula: '123', turma: turma) }
      
      it 'student pertence a turma' do
        expect(student.turma).to eq(turma)
      end
      
      it 'student tem atributos corretos' do
        expect(student.name).to eq('Aluno')
        expect(student.email).to eq('student@test.com')
        expect(student.matricula).to eq('123')
      end
    end
  end
  
  describe 'Serialization coverage' do
    let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    
    context 'Respostum serialization' do
      it 'serializa dados JSON corretamente' do
        dados = { '1' => 'Resposta', '2' => ['a', 'b', 'c'] }
        resposta = Respostum.create!(
          data_resposta: dados,
          status: 'enviado',
          user: user,
          formulario: formulario
        )
        
        resposta.reload
        expect(resposta.data_resposta).to eq(dados)
        expect(resposta.data_resposta['1']).to eq('Resposta')
        expect(resposta.data_resposta['2']).to eq(['a', 'b', 'c'])
      end
      
      it 'aceita dados nil' do
        resposta = Respostum.create!(
          data_resposta: nil,
          status: 'rascunho',
          user: user,
          formulario: formulario
        )
        
        expect(resposta.data_resposta).to be_nil
      end
    end
  end
  
  describe 'Validation edge cases' do
    context 'User validations' do
      it 'valida presença de campos obrigatórios' do
        user = User.new
        expect(user).not_to be_valid
        expect(user.errors[:nome]).to include("can't be blank")
        expect(user.errors[:email]).to include("can't be blank")
        expect(user.errors[:matricula]).to include("can't be blank")
      end
    end
    
    context 'Template validations' do
      let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
      
      it 'valida presença de nome' do
        template = Template.new(user: user)
        expect(template).not_to be_valid
        expect(template.errors[:nome]).to include("can't be blank")
      end
    end
    
    context 'Questao validations' do
      let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
      let!(:template) { Template.create!(nome: 'Template', user: user) }
      
      it 'valida presença de texto' do
        questao = Questao.new(template: template)
        expect(questao).not_to be_valid
        expect(questao.errors[:texto]).to include("can't be blank")
      end
    end
  end
end