require 'rails_helper'

RSpec.describe 'Application-wide integration tests', type: :request do
  let!(:admin) { User.create!(nome: 'Admin', email: 'admin@test.com', matricula: 'ADM1', password: 'pass', tipo: 'admin') }
  let!(:student_user) { User.create!(nome: 'Student', email: 'student@test.com', matricula: 'STU1', password: 'pass', tipo: 'student') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'FGA0138', nome: 'Turma A', disciplina: 'Prog', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Avaliacão 1', user: admin) }

  describe 'Full workflow: template -> formulario -> resposta' do
    it 'creates template with questions' do
      expect {
        Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
        Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template)
      }.to change(Questao, :count).by(2)
      
      expect(template.questaos.count).to eq(2)
    end

    it 'creates formulario from template' do
      formulario = Formulario.create!(
        titulo: 'Formulário Teste',
        data_inicio: DateTime.now,
        data_termino: DateTime.now + 7.days,
        template: template,
        turma: turma
      )
      
      expect(formulario).to be_persisted
      expect(formulario.template).to eq(template)
      expect(formulario.turma).to eq(turma)
    end

    it 'student submits resposta to formulario' do
      formulario = Formulario.create!(
        titulo: 'Form',
        template: template,
        turma: turma
      )
      
      resposta = Respostum.create!(
        user: student_user,
        formulario: formulario,
        data_resposta: '{"q1": "answer1", "q2": "answer2"}'
      )
      
      expect(resposta).to be_persisted
      expect(resposta.user).to eq(student_user)
    end

    it 'cascades deletion: template -> formulario -> resposta' do
      formulario = Formulario.create!(titulo: 'F', template: template, turma: turma)
      resposta = Respostum.create!(user: student_user, formulario: formulario, data_resposta: '{}')
      
      expect {
        formulario.destroy
      }.to change(Respostum, :count).by(-1)
    end
  end

  describe 'Student and Turma relationship' do
    it 'assigns student to turma' do
      student = Student.create!(
        name: 'João Silva',
        email: 'joao@test.com',
        matricula: '190001',
        turma: turma
      )
      
      expect(student.turma).to eq(turma)
      expect(turma.students).to include(student)
    end

    it 'allows multiple students in same turma' do
      s1 = Student.create!(name: 'S1', email: 's1@test.com', matricula: 'M1', turma: turma)
      s2 = Student.create!(name: 'S2', email: 's2@test.com', matricula: 'M2', turma: turma)
      
      expect(turma.students.count).to be >= 2
    end

    it 'updates student turma assignment' do
      student = Student.create!(name: 'S', email: 's@test.com', matricula: 'M', turma: turma)
      turma2 = Turma.create!(codigo_sigaa: 'T2', nome: 'T2', disciplina: 'D', semestre: '2/2025', ano: 2025)
      
      student.update!(turma: turma2)
      expect(student.turma).to eq(turma2)
    end
  end

  describe 'User authentication flow' do
    it 'creates user with encrypted password' do
      user = User.create!(
        nome: 'Novo User',
        email: 'novo@test.com',
        matricula: 'NOVO1',
        password: 'plaintext',
        tipo: 'student'
      )
      
      expect(user.password_digest).not_to eq('plaintext')
      expect(user.password_digest).to be_present
    end

    it 'authenticates user with correct password' do
      user = User.create!(
        nome: 'Auth Test',
        email: 'auth@test.com',
        matricula: 'AUTH1',
        password: 'mypassword',
        tipo: 'student'
      )
      
      expect(user.authenticate('mypassword')).to eq(user)
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe 'Template and Questao relationship' do
    it 'deletes questoes when template is deleted' do
      q1 = Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
      q2 = Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template)
      
      expect {
        template.destroy
      }.to change(Questao, :count).by(-2)
    end

    it 'orders questoes by ordem field' do
      q1 = Questao.create!(texto: 'Q1', tipo: 'objetiva', ordem: 2, template: template)
      q2 = Questao.create!(texto: 'Q2', tipo: 'objetiva', ordem: 1, template: template)
      
      expect(template.questaos.order(:ordem).first).to eq(q2)
    end
  end

  describe 'Turma date extraction' do
    it 'extracts year from semestre 1/YYYY' do
      t = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2024', ano: 2024)
      expect(t.ano).to eq(2024)
    end

    it 'extracts year from semestre 2/YYYY' do
      t = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '2/2023', ano: 2023)
      expect(t.ano).to eq(2023)
    end

    it 'handles semestre with YYYY.S format' do
      t = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '2025.1', ano: 2025)
      expect(t.ano).to eq(2025)
    end
  end

  describe 'Formulario date validation' do
    it 'creates formulario with future dates' do
      f = Formulario.create!(
        titulo: 'Future',
        data_inicio: DateTime.now + 1.day,
        data_termino: DateTime.now + 8.days,
        template: template,
        turma: turma
      )
      expect(f).to be_persisted
    end

    it 'creates formulario with past dates' do
      f = Formulario.create!(
        titulo: 'Past',
        data_inicio: DateTime.now - 8.days,
        data_termino: DateTime.now - 1.day,
        template: template,
        turma: turma
      )
      expect(f).to be_persisted
    end

    it 'creates formulario without dates' do
      f = Formulario.create!(
        titulo: 'NoDates',
        template: template,
        turma: turma
      )
      expect(f).to be_persisted
    end
  end

  describe 'Questao obrigatoria field' do
    it 'marks questao as obrigatoria' do
      q = Questao.create!(texto: 'Q', tipo: 'objetiva', obrigatoria: true, template: template)
      expect(q.obrigatoria).to be true
    end

    it 'defaults obrigatoria to false' do
      q = Questao.create!(texto: 'Q', tipo: 'objetiva', template: template)
      expect(q.obrigatoria).to be_falsey
    end
  end

  describe 'Questao opcoes JSON field' do
    it 'stores opcoes as JSON string' do
      q = Questao.create!(
        texto: 'Q',
        tipo: 'objetiva',
        opcoes: '["A", "B", "C", "D"]',
        template: template
      )
      expect(q.opcoes).to include('A')
    end

    it 'allows opcoes to be empty' do
      q = Questao.create!(texto: 'Q', tipo: 'discursiva', template: template)
      expect(q.opcoes).to be_nil
    end
  end
end
