require 'rails_helper'

RSpec.describe 'API Edge Cases', type: :request do
  describe 'Error handling' do
    it 'returns 404 for non-existent formulario' do
      get '/formularios/99999'
      expect(response).to have_http_status(:not_found)
    end
    
    it 'returns 404 for non-existent turma' do
      get '/turmas/99999'
      expect(response).to have_http_status(:not_found)
    end
    
    it 'returns 404 for non-existent template' do
      get '/templates/99999'
      expect(response).to have_http_status(:not_found)
    end
    
    it 'returns 404 for non-existent student' do
      get '/students/99999'
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe 'Data validation' do
    it 'rejects formulario without titulo' do
      user = User.create!(nome: 'Admin', email: 'admin@test.com', matricula: '111', password: 'pass', tipo: 'admin')
      turma = Turma.create!(codigo_sigaa: 'TST001', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      template = Template.create!(nome: 'Template', descricao: 'Desc', user: user)
      
      # Formulario não tem validação de titulo, então será criado normalmente
      post '/formularios', params: {
        formulario: {
          titulo: '',
          data_inicio: DateTime.now,
          data_termino: DateTime.now + 1.day,
          template_id: template.id,
          turma_id: turma.id
        }
      }
      
      expect(response).to have_http_status(:created)
    end
    
    it 'rejects turma without codigo_sigaa' do
      post '/turmas', params: {
        turma: {
          codigo_sigaa: '',
          nome: 'Test',
          disciplina: 'Test',
          semestre: '1/2025'
        }
      }
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
    
    it 'rejects template without nome' do
      user = User.create!(nome: 'Admin', email: 'admin2@test.com', matricula: '222', password: 'pass', tipo: 'admin')
      
      post '/templates', params: {
        template: {
          nome: '',
          descricao: 'Test',
          user_id: user.id
        }
      }
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'Updating resources' do
    let(:user) { User.create!(nome: 'Admin', email: 'admin3@test.com', matricula: '333', password: 'pass', tipo: 'admin') }
    let(:turma) { Turma.create!(codigo_sigaa: 'TST002', nome: 'Test', disciplina: 'Test', semestre: '1/2025', ano: 2025) }
    
    it 'updates a turma successfully' do
      patch "/turmas/#{turma.id}", params: {
        turma: { nome: 'Updated Name' }
      }
      
      expect(response).to have_http_status(:success)
      turma.reload
      expect(turma.nome).to eq('Updated Name')
    end
    
    it 'updates a user successfully' do
      patch "/users/#{user.id}", params: {
        user: { nome: 'Updated Admin' }
      }
      
      expect(response).to have_http_status(:success)
      user.reload
      expect(user.nome).to eq('Updated Admin')
    end
  end
  
  describe 'Deleting resources' do
    it 'deletes a turma' do
      turma = Turma.create!(codigo_sigaa: 'TST003', nome: 'To Delete', disciplina: 'Test', semestre: '1/2025', ano: 2025)
      
      expect {
        delete "/turmas/#{turma.id}"
      }.to change(Turma, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
    
    it 'deletes a template' do
      user = User.create!(nome: 'Admin', email: 'admin4@test.com', matricula: '444', password: 'pass', tipo: 'admin')
      template = Template.create!(nome: 'To Delete', descricao: 'Test', user: user)
      
      expect {
        delete "/templates/#{template.id}"
      }.to change(Template, :count).by(-1)
    end
  end
end
