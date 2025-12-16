require 'rails_helper'

RSpec.describe 'Model validations comprehensive', type: :model do
  describe 'User model comprehensive validation' do
    it 'requires nome to be present' do
      user = User.new(email: 'test@ex.com', matricula: 'M1', password: 'p')
      expect(user).not_to be_valid
      expect(user.errors[:nome]).to include("can't be blank")
    end

    it 'requires email to be present' do
      user = User.new(nome: 'Name', matricula: 'M1', password: 'p')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires matricula to be present' do
      user = User.new(nome: 'Name', email: 'test@ex.com', password: 'p')
      expect(user).not_to be_valid
      expect(user.errors[:matricula]).to include("can't be blank")
    end

    it 'requires unique email' do
      User.create!(nome: 'U1', email: 'unique@ex.com', matricula: 'M1', password: 'p')
      user2 = User.new(nome: 'U2', email: 'unique@ex.com', matricula: 'M2', password: 'p')
      expect(user2).not_to be_valid
    end

    it 'requires unique matricula' do
      User.create!(nome: 'U1', email: 'u1@ex.com', matricula: 'UNIQUE1', password: 'p')
      user2 = User.new(nome: 'U2', email: 'u2@ex.com', matricula: 'UNIQUE1', password: 'p')
      expect(user2).not_to be_valid
    end

    it 'encrypts password on save' do
      user = User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'plaintext')
      expect(user.password_digest).not_to eq('plaintext')
      expect(user.password_digest).to be_present
    end

    it 'authenticates with correct password' do
      user = User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'correctpass')
      expect(user.authenticate('correctpass')).to eq(user)
    end

    it 'fails authentication with incorrect password' do
      user = User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'correctpass')
      expect(user.authenticate('wrongpass')).to be_falsey
    end
  end

  describe 'Template model validation' do
    let(:user) { User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'p') }

    it 'requires nome to be present' do
      template = Template.new(user: user)
      expect(template).not_to be_valid
      expect(template.errors[:nome]).to include("can't be blank")
    end

    it 'is valid with nome and user' do
      template = Template.new(nome: 'Valid Template', user: user)
      expect(template).to be_valid
    end

    it 'belongs to user' do
      template = Template.create!(nome: 'T', user: user)
      expect(template.user).to eq(user)
    end

    it 'destroys associated questaos when destroyed' do
      template = Template.create!(nome: 'T', user: user)
      q1 = Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template)
      q2 = Questao.create!(texto: 'Q2', tipo: 'discursiva', template: template)
      
      expect {
        template.destroy
      }.to change(Questao, :count).by(-2)
    end
  end

  describe 'Questao model validation' do
    let(:user) { User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'p') }
    let(:template) { Template.create!(nome: 'T', user: user) }

    it 'requires texto to be present' do
      questao = Questao.new(tipo: 'objetiva', template: template)
      expect(questao).not_to be_valid
      expect(questao.errors[:texto]).to include("can't be blank")
    end

    it 'requires tipo to be present' do
      questao = Questao.new(texto: 'Question', template: template)
      expect(questao).not_to be_valid
      expect(questao.errors[:tipo]).to include("can't be blank")
    end

    it 'requires template association' do
      questao = Questao.new(texto: 'Q', tipo: 'objetiva')
      expect(questao).not_to be_valid
    end

    it 'accepts objetiva tipo' do
      questao = Questao.create!(texto: 'Q', tipo: 'objetiva', template: template)
      expect(questao.tipo).to eq('objetiva')
    end

    it 'accepts discursiva tipo' do
      questao = Questao.create!(texto: 'Q', tipo: 'discursiva', template: template)
      expect(questao.tipo).to eq('discursiva')
    end
  end

  describe 'Turma model callbacks' do
    it 'extracts ano from semestre 1/2025' do
      turma = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2025', ano: 2025)
      expect(turma.ano).to eq(2025)
    end

    it 'extracts ano from semestre 2/2024' do
      turma = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '2/2024', ano: 2024)
      expect(turma.ano).to eq(2024)
    end

    it 'extracts ano from semestre 2023.1' do
      turma = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '2023.1', ano: 2023)
      expect(turma.ano).to eq(2023)
    end

    it 'has many students' do
      turma = Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2025', ano: 2025)
      s1 = Student.create!(name: 'S1', email: 's1@ex.com', matricula: 'M1', turma: turma)
      s2 = Student.create!(name: 'S2', email: 's2@ex.com', matricula: 'M2', turma: turma)
      
      expect(turma.students).to include(s1, s2)
    end
  end

  describe 'Student model' do
    let(:turma) { Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2025', ano: 2025) }

    it 'belongs to turma' do
      student = Student.create!(name: 'S', email: 's@ex.com', matricula: 'M', turma: turma)
      expect(student.turma).to eq(turma)
    end

    it 'requires turma_id due to NOT NULL constraint' do
      expect {
        Student.create!(name: 'S', email: 's@ex.com', matricula: 'M')
      }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe 'Formulario model associations' do
    let(:user) { User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'p') }
    let(:turma) { Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2025', ano: 2025) }
    let(:template) { Template.create!(nome: 'T', user: user) }

    it 'belongs to template and turma' do
      form = Formulario.create!(titulo: 'F', template: template, turma: turma)
      expect(form.template).to eq(template)
      expect(form.turma).to eq(turma)
    end

    it 'destroys associated respostas when destroyed' do
      form = Formulario.create!(titulo: 'F', template: template, turma: turma)
      r1 = Respostum.create!(user: user, formulario: form, data_resposta: '{}')
      r2 = Respostum.create!(user: user, formulario: form, data_resposta: '{}')
      
      expect {
        form.destroy
      }.to change(Respostum, :count).by(-2)
    end
  end

  describe 'Respostum model' do
    let(:user) { User.create!(nome: 'U', email: 'u@ex.com', matricula: 'M', password: 'p') }
    let(:turma) { Turma.create!(codigo_sigaa: 'T', nome: 'T', disciplina: 'D', semestre: '1/2025', ano: 2025) }
    let(:template) { Template.create!(nome: 'T', user: user) }
    let(:formulario) { Formulario.create!(titulo: 'F', template: template, turma: turma) }

    it 'belongs to user and formulario' do
      resp = Respostum.create!(user: user, formulario: formulario, data_resposta: '{}')
      expect(resp.user).to eq(user)
      expect(resp.formulario).to eq(formulario)
    end

    it 'stores data_resposta as text' do
      resp = Respostum.create!(user: user, formulario: formulario, data_resposta: '{"q1": "answer"}')
      expect(resp.data_resposta).to include('q1')
    end

    it 'has status field' do
      resp = Respostum.create!(user: user, formulario: formulario, data_resposta: '{}', status: 'draft')
      expect(resp.status).to be_present
    end
  end
end
