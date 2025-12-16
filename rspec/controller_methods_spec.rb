require 'rails_helper'

# Testes específicos de métodos dos controllers para melhorar cobertura
RSpec.describe 'Controller Methods Coverage', type: :request do
  
  describe 'Sessions Controller métodos específicos' do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123', nome: 'Test User', tipo: 'aluno', matricula: '111111') }
    
    context 'autenticação com diferentes cenários' do
      it 'autentica usuário professor (Happy Path)' do
        professor = User.create!(email: 'prof@example.com', password: 'senha123', nome: 'Professor', tipo: 'professor', matricula: '222222')
        post '/login', params: { email: professor.email, password: 'senha123' }
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['user']['tipo']).to eq('professor')
      end
      
      it 'falha com email inexistente (Sad Path)' do
        post '/login', params: { email: 'inexistente@example.com', password: 'qualquer' }
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Email ou senha inválidos')
      end
      
      it 'falha com parâmetros vazios (Sad Path)' do
        post '/login', params: { email: '', password: '' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  
  describe 'Admin::ImportarController métodos específicos' do
    context 'importação sem arquivo (Sad Path)' do
      it 'retorna erro quando não envia arquivo' do
        post '/admin/importar'
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Nenhum arquivo enviado.')
      end
      
      it 'retorna erro com formato inválido' do
        file = fixture_file_upload('/tmp/test.txt', 'text/plain')
        post '/admin/importar', params: { csvFile: file }
        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Formato de arquivo não suportado. Use .csv ou .json')
      end
    end
  end
  
  describe 'Formularios Controller filtros específicos' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: user) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    
    context 'filtros por data' do
      it 'filtra apenas formulários ativos por data (Happy Path)' do
        # Formulário ativo
        Formulario.create!(
          titulo: 'Ativo',
          data_inicio: 1.day.ago,
          data_termino: 1.day.from_now,
          template: template,
          turma: turma
        )
        
        # Formulário expirado
        Formulario.create!(
          titulo: 'Expirado',
          data_inicio: 3.days.ago,
          data_termino: 2.days.ago,
          template: template,
          turma: turma
        )
        
        # Formulário futuro
        Formulario.create!(
          titulo: 'Futuro',
          data_inicio: 2.days.from_now,
          data_termino: 3.days.from_now,
          template: template,
          turma: turma
        )
        
        get '/formularios'
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['titulo']).to eq('Ativo')
      end
    end
  end
  
  describe 'Respostas Controller casos específicos' do
    let!(:user) { User.create!(nome: 'Aluno', email: 'aluno@test.com', password: 'senha123', tipo: 'aluno', matricula: '111111') }
    let!(:professor) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    let!(:template) { Template.create!(nome: 'Template', user: professor) }
    let!(:turma) { Turma.create!(codigo_sigaa: 'CIC123', nome: 'Turma', disciplina: 'Disciplina', semestre: '2024.1') }
    let!(:formulario) { Formulario.create!(titulo: 'Form', data_inicio: 1.day.ago, data_termino: 1.day.from_now, template: template, turma: turma) }
    
    context 'criação com diferentes status' do
      it 'cria resposta com status padrão enviado (Happy Path)' do
        post '/respostas', params: {
          resposta: { '1' => 'Resposta teste' },
          user_id: user.id,
          formulario_id: formulario.id
        }
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('enviado')
      end
      
      it 'cria resposta com dados nil (Happy Path)' do
        post '/respostas', params: {
          resposta: nil,
          user_id: user.id,
          formulario_id: formulario.id
        }
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['data_resposta']).to be_nil
      end
    end
  end
  
  describe 'Templates Controller com questões' do
    let!(:user) { User.create!(nome: 'Professor', email: 'prof@test.com', password: 'senha123', tipo: 'professor', matricula: '123456') }
    
    context 'templates com relacionamentos' do
      it 'cria template e verifica relacionamentos (Happy Path)' do
        post '/templates', params: {
          template: {
            nome: 'Template com Questões',
            descricao: 'Template para testar relacionamentos',
            user_id: user.id
          }
        }
        expect(response).to have_http_status(:created)
        
        template = Template.last
        expect(template.questoes).to be_empty
        expect(template.formularios).to be_empty
      end
    end
  end
  
  describe 'Users Controller casos específicos' do
    context 'diferentes tipos de usuário' do
      it 'cria usuário admin (Happy Path)' do
        post '/users', params: {
          user: {
            nome: 'Admin User',
            email: 'admin@test.com',
            password: 'senha123',
            tipo: 'admin',
            matricula: '999999'
          }
        }
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['tipo']).to eq('admin')
      end
      
      it 'cria usuário professor (Happy Path)' do
        post '/users', params: {
          user: {
            nome: 'Professor User',
            email: 'professor@test.com',
            password: 'senha123',
            tipo: 'professor',
            matricula: '888888'
          }
        }
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['tipo']).to eq('professor')
      end
    end
  end
end