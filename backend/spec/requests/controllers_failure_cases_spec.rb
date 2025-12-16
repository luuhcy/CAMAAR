require 'rails_helper'

RSpec.describe 'Controller failure cases', type: :request do
  describe 'TemplatesController' do
    it 'returns 404 for show missing' do
      get '/templates/999999'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 422 on invalid create' do
      post '/templates', params: { template: { nome: '' } }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'StudentsController' do
    it 'returns 404 for show missing' do
      get '/students/999999'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 422 on invalid create' do
      post '/students', params: { student: { name: '', email: '', matricula: '' } }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'QuestaosController' do
    it 'returns 404 for show missing' do
      get '/questaos/999999'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 422 on invalid create' do
      post '/questaos', params: { questao: { texto: '', tipo: '' } }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'TurmasController' do
    it 'returns 404 for show missing' do
      get '/turmas/999999'
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 422 on invalid create' do
      post '/turmas', params: { turma: { codigo_sigaa: '', semestre: '' } }
      expect(response.status).to satisfy { |s| [400, 422].include?(s) }
    end
  end

  describe 'FormulariosController' do
    it 'returns 404 for show missing' do
      get '/formularios/999999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'RespostasController' do
    it 'returns 404 for show missing' do
      get '/respostas/999999'
      expect(response).to have_http_status(:not_found)
    end
  end
end
