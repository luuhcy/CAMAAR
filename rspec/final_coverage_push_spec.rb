require 'rails_helper'

# Testes finais para alcançar 90% de cobertura
RSpec.describe 'Final Coverage Push', type: :request do
  
  describe 'Controller includes coverage' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    
    context 'FormulariosController includes' do
      it 'carrega associações no index' do
        get '/formularios'
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        if json_response.any?
          expect(json_response.first).to have_key('turma')
          expect(json_response.first).to have_key('template')
        end
      end
      
      it 'carrega associações no show' do
        get "/formularios/#{formulario.id}"
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('turma')
        expect(json_response).to have_key('template')
        expect(json_response['template']).to have_key('user')
      end
    end
  end
  
  describe 'Model attribute access' do
    let!(:user) { User.create!(nome: 'Test User', email: 'test@test.com', password: 'senha123', tipo: 'aluno', matricula: '123456') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '654321') }
    let!(:template) { Template.create!(nome: 'Template', descricao: 'Descrição', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1', ano: 2024) }
    
    context 'todos os atributos dos models' do
      it 'acessa todos os atributos de User' do
        expect(user.id).to be_present
        expect(user.nome).to eq('Test User')
        expect(user.email).to eq('test@test.com')
        expect(user.matricula).to eq('123456')
        expect(user.tipo).to eq('aluno')
        expect(user.password_digest).to be_present
        expect(user.created_at).to be_present
        expect(user.updated_at).to be_present
      end
      
      it 'acessa todos os atributos de Template' do
        expect(template.id).to be_present
        expect(template.nome).to eq('Template')
        expect(template.descricao).to eq('Descrição')
        expect(template.user_id).to eq(professor.id)
        expect(template.created_at).to be_present
        expect(template.updated_at).to be_present
      end
      
      it 'acessa todos os atributos de Turma' do
        expect(turma.id).to be_present
        expect(turma.codigo_sigaa).to eq('CIC123')
        expect(turma.nome).to eq('Turma')
        expect(turma.disciplina).to eq('Disciplina')
        expect(turma.semestre).to eq('2024.1')
        expect(turma.ano).to eq(2024)
        expect(turma.created_at).to be_present
        expect(turma.updated_at).to be_present
      end
    end
  end
  
  describe 'JSON serialization paths' do
    let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    let!(:questao) { Questao.create!(texto: 'Pergunta', tipo: 'texto', template: template, ordem: 1, obrigatoria: true) }
    let!(:student) { Student.create!(name: 'Student', email: 'student@test.com', matricula: '123', turma: turma) }
    
    context 'diferentes formatos de resposta JSON' do
      it 'retorna JSON com estrutura completa para formularios' do
        get "/formularios/#{formulario.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['turma']).to have_key('codigo_sigaa')
        expect(json['turma']).to have_key('nome')
        expect(json['turma']).to have_key('disciplina')
        expect(json['template']['user']).to have_key('nome')
      end
      
      it 'retorna JSON simples para outros controllers' do
        get "/questaos/#{questao.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to have_key('texto')
        expect(json).to have_key('tipo')
        expect(json).to have_key('ordem')
        expect(json).to have_key('obrigatoria')
      end
      
      it 'retorna JSON para students' do
        get "/students/#{student.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to have_key('name')
        expect(json).to have_key('email')
        expect(json).to have_key('matricula')
      end
    end
  end
  
  describe 'Controller action coverage' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    context 'diferentes paths de resposta' do
      it 'testa location header na criação' do
        post '/formularios', params: {
          formulario: {
            titulo: 'Form com Location',
            data_inicio: 1.day.from_now,
            data_termino: 7.days.from_now,
            template_id: template.id,
            turma_id: turma.id
          }
        }
        expect(response).to have_http_status(:created)
        expect(response.headers['Location']).to be_present
      end
      
      it 'testa diferentes status de erro' do
        post '/formularios', params: { formulario: { titulo: '' } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
  
  describe 'Model callback coverage' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    
    context 'dependent destroy' do
      it 'testa dependent destroy do template' do
        questao = Questao.create!(texto: 'Pergunta', tipo: 'texto', template: template)
        expect { template.destroy }.to change(Questao, :count).by(-1)
      end
    end
  end
end