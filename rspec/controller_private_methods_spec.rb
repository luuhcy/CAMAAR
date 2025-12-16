require 'rails_helper'

# Testes para cobrir métodos privados dos controllers
RSpec.describe 'Controller Private Methods Coverage', type: :request do
  
  describe 'Strong Parameters coverage' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    context 'FormulariosController params' do
      it 'aceita todos os parâmetros válidos' do
        params = {
          formulario: {
            titulo: 'Formulário Completo',
            data_inicio: 1.day.from_now,
            data_termino: 7.days.from_now,
            template_id: template.id,
            turma_id: turma.id
          }
        }
        post '/formularios', params: params
        expect(response).to have_http_status(:created)
      end
      
      it 'ignora parâmetros não permitidos' do
        params = {
          formulario: {
            titulo: 'Formulário',
            data_inicio: 1.day.from_now,
            data_termino: 7.days.from_now,
            template_id: template.id,
            turma_id: turma.id,
            parametro_nao_permitido: 'valor'
          }
        }
        post '/formularios', params: params
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'QuestaosController params' do
      it 'aceita todos os parâmetros de questão' do
        params = {
          questao: {
            texto: 'Pergunta completa',
            tipo: 'multipla_escolha',
            obrigatoria: true,
            ordem: 1,
            opcoes: '["A", "B", "C"]',
            template_id: template.id
          }
        }
        post '/questaos', params: params
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'UsersController params' do
      it 'aceita todos os parâmetros de usuário' do
        params = {
          user: {
            nome: 'Usuário Completo',
            email: 'completo@test.com',
            password: 'senha123',
            tipo: 'aluno',
            matricula: '999999'
          }
        }
        post '/users', params: params
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'StudentsController params' do
      it 'aceita todos os parâmetros de estudante' do
        params = {
          student: {
            name: 'Estudante Completo',
            email: 'estudante@test.com',
            matricula: '888888',
            turma_id: turma.id
          }
        }
        post '/students', params: params
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'TemplatesController params' do
      it 'aceita todos os parâmetros de template' do
        params = {
          template: {
            nome: 'Template Completo',
            descricao: 'Descrição completa do template',
            user_id: user.id
          }
        }
        post '/templates', params: params
        expect(response).to have_http_status(:created)
      end
    end
    
    context 'TurmasController params' do
      it 'aceita todos os parâmetros de turma' do
        params = {
          turma: {
            codigo_sigaa: 'CIC999',
            nome: 'Turma Completa',
            disciplina: 'Disciplina Completa',
            semestre: '2024.2',
            ano: 2024
          }
        }
        post '/turmas', params: params
        expect(response).to have_http_status(:created)
      end
    end
  end
  
  describe 'Set methods coverage' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    let!(:questao) { Questao.create!(texto: 'Pergunta', tipo: 'texto', template: template) }
    let!(:aluno) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:resposta) { Respostum.create!(data_resposta: {'1' => 'Resp'}, status: 'enviado', user: aluno, formulario: formulario) }
    
    context 'métodos show que usam set_*' do
      it 'show de formulario usa set_formulario' do
        get "/formularios/#{formulario.id}"
        expect(response).to have_http_status(:ok)
      end
      
      it 'show de questao usa set_questao' do
        get "/questaos/#{questao.id}"
        expect(response).to have_http_status(:ok)
      end
      
      it 'show de resposta usa set_resposta' do
        get "/respostas/#{resposta.id}"
        expect(response).to have_http_status(:ok)
      end
      
      it 'show de user usa set_user' do
        get "/users/#{user.id}"
        expect(response).to have_http_status(:ok)
      end
      
      it 'show de template usa set_template' do
        get "/templates/#{template.id}"
        expect(response).to have_http_status(:ok)
      end
    end
    
    context 'métodos update que usam set_*' do
      it 'update de formulario usa set_formulario' do
        put "/formularios/#{formulario.id}", params: { formulario: { titulo: 'Novo Título' } }
        expect(response).to have_http_status(:ok)
      end
      
      it 'update de questao usa set_questao' do
        put "/questaos/#{questao.id}", params: { questao: { texto: 'Nova Pergunta' } }
        expect(response).to have_http_status(:ok)
      end
      
      it 'update de resposta usa set_resposta' do
        put "/respostas/#{resposta.id}", params: { respostum: { status: 'revisado' } }
        expect(response).to have_http_status(:ok)
      end
    end
    
    context 'métodos destroy que usam set_*' do
      it 'destroy de formulario usa set_formulario' do
        delete "/formularios/#{formulario.id}"
        expect(response).to have_http_status(:no_content)
      end
      
      it 'destroy de questao usa set_questao' do
        questao2 = Questao.create!(texto: 'Para deletar', tipo: 'texto', template: template)
        delete "/questaos/#{questao2.id}"
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end