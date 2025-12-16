require 'rails_helper'

# Testes de métodos específicos dos models para cobertura
RSpec.describe 'Model Methods Coverage', type: :model do
  
  describe 'User model methods' do
    let!(:user) { User.create!(nome: 'Test User', email: 'test@test.com', password: 'senha123', tipo: 'aluno', matricula: '123456') }
    
    it 'user tem password_digest' do
      expect(user.password_digest).to be_present
    end
    
    it 'user pode ser atualizado' do
      user.update!(nome: 'Updated User')
      expect(user.nome).to eq('Updated User')
    end
    
    it 'user pode ter tipo alterado' do
      user.update!(tipo: 'professor')
      expect(user.tipo).to eq('professor')
    end
    
    it 'user mantém created_at e updated_at' do
      expect(user.created_at).to be_present
      expect(user.updated_at).to be_present
    end
  end
  
  describe 'Template model methods' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template Test', descricao: 'Desc', user: user) }
    
    it 'template pode ser atualizado' do
      template.update!(nome: 'Updated Template')
      expect(template.nome).to eq('Updated Template')
    end
    
    it 'template mantém timestamps' do
      expect(template.created_at).to be_present
      expect(template.updated_at).to be_present
    end
    
    it 'template pode ter descricao alterada' do
      template.update!(descricao: 'Nova descrição')
      expect(template.descricao).to eq('Nova descrição')
    end
  end
  
  describe 'Student model methods' do
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:student) { Student.create!(name: 'Student Test', email: 'student@test.com', matricula: '123', turma: turma) }
    
    it 'student pode ser atualizado' do
      student.update!(name: 'Updated Student')
      expect(student.name).to eq('Updated Student')
    end
    
    it 'student pode ter email alterado' do
      student.update!(email: 'new@test.com')
      expect(student.email).to eq('new@test.com')
    end
    
    it 'student mantém timestamps' do
      expect(student.created_at).to be_present
      expect(student.updated_at).to be_present
    end
  end
  
  describe 'Turma model methods' do
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    it 'turma pode ser atualizada' do
      turma.update!(nome: 'Turma Atualizada')
      expect(turma.nome).to eq('Turma Atualizada')
    end
    
    it 'turma pode ter disciplina alterada' do
      turma.update!(disciplina: 'Nova Disciplina')
      expect(turma.disciplina).to eq('Nova Disciplina')
    end
    
    it 'turma pode ter ano definido' do
      turma.update!(semestre: '1/2025')
      expect(turma.ano).to eq(2025)
    end
    
    it 'turma mantém timestamps' do
      expect(turma.created_at).to be_present
      expect(turma.updated_at).to be_present
    end
  end
  
  describe 'Questao model methods' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:questao) { Questao.create!(texto: 'Pergunta', tipo: 'texto', template: template) }
    
    it 'questao pode ser atualizada' do
      questao.update!(texto: 'Pergunta Atualizada')
      expect(questao.texto).to eq('Pergunta Atualizada')
    end
    
    it 'questao pode ter tipo alterado' do
      questao.update!(tipo: 'multipla_escolha')
      expect(questao.tipo).to eq('multipla_escolha')
    end
    
    it 'questao pode ter ordem definida' do
      questao.update!(ordem: 5)
      expect(questao.ordem).to eq(5)
    end
    
    it 'questao pode ser obrigatória' do
      questao.update!(obrigatoria: true)
      expect(questao.obrigatoria).to be true
    end
    
    it 'questao pode ter opções' do
      questao.update!(opcoes: '["A", "B", "C"]')
      expect(questao.opcoes).to eq('["A", "B", "C"]')
    end
  end
  
  describe 'Formulario model methods' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    
    it 'formulario pode ser atualizado' do
      formulario.update!(titulo: 'Formulário Atualizado')
      expect(formulario.titulo).to eq('Formulário Atualizado')
    end
    
    it 'formulario pode ter datas alteradas' do
      nova_data = 2.days.from_now
      formulario.update!(data_termino: nova_data)
      expect(formulario.data_termino.to_date).to eq(nova_data.to_date)
    end
  end
  
  describe 'Respostum model methods' do
    let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    let!(:resposta) { Respostum.create!(data_resposta: {'1' => 'Resposta'}, status: 'enviado', user: user, formulario: formulario) }
    
    it 'resposta pode ser atualizada' do
      resposta.update!(status: 'revisado')
      expect(resposta.status).to eq('revisado')
    end
    
    it 'resposta pode ter dados alterados' do
      novos_dados = {'1' => 'Nova Resposta', '2' => 'Segunda'}
      resposta.update!(data_resposta: novos_dados)
      expect(resposta.data_resposta).to eq(novos_dados)
    end
    
    it 'resposta mantém timestamps' do
      expect(resposta.created_at).to be_present
      expect(resposta.updated_at).to be_present
    end
  end
end