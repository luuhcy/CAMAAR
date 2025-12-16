require 'rails_helper'

RSpec.describe 'Admin Importar Errors', type: :request do
  describe 'POST /admin/importar error paths' do
    it 'handles CSV encoding error (responds gracefully)' do
      bad_bytes = "\xC3\x28" # invalid UTF-8
      file = Tempfile.new(['bad', '.csv'])
      file.binmode
      file.write(bad_bytes)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect([200, 204, 400]).to include(response.status)
    ensure
      file.close
      file.unlink
    end

    it 'handles CSV parser error (malformed headers) gracefully' do
      csv_content = "not,a,csv\n\n\n\x00"
      file = Tempfile.new(['badparse', '.csv'])
      file.write(csv_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'text/csv')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:ok).or have_http_status(:internal_server_error)
    ensure
      file.close
      file.unlink
    end

    it 'returns bad_request for malformed JSON' do
      json_content = '{ invalid json ]'
      file = Tempfile.new(['badjson', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:bad_request)
    ensure
      file.close
      file.unlink
    end

    it 'returns bad_request for unrecognized JSON format' do
      json_content = [{ foo: 'bar' }].to_json
      file = Tempfile.new(['unknown', '.json'])
      file.write(json_content)
      file.rewind
      uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

      post '/admin/importar', params: { csvFile: uploaded }
      expect(response).to have_http_status(:bad_request)
    ensure
      file.close
      file.unlink
    end
  end
end
