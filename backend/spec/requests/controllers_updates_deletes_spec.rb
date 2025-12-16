require 'rails_helper'

RSpec.describe 'Controllers updates and deletes', type: :request do
  let!(:admin) { User.create!(nome: 'Admin', email: 'admin@ex.com', matricula: 'A1', password: 'pass', tipo: 'admin') }
  let!(:turma) { Turma.create!(codigo_sigaa: 'TST10', nome: 'Nome', disciplina: 'Disc', semestre: '1/2025', ano: 2025) }
  let!(:template) { Template.create!(nome: 'Tpl', descricao: 'Desc', user: admin) }
  let!(:form) { Formulario.create!(titulo: 'F1', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma) }
  let!(:questao) { Questao.create!(texto: 'Q1', tipo: 'objetiva', template: template) }
  let!(:student) { Student.create!(name: 'Stu', email: 's@ex.com', matricula: 'M1', turma: turma) }
  let!(:resp) { Respostum.create!(user: admin, formulario: form, data_resposta: '{"q1":"a"}') }

  it 'rejects invalid template update' do
    patch "/templates/#{template.id}", params: { template: { nome: '' } }
    expect(response.status).to satisfy { |s| [400, 422].include?(s) }
  end

  it 'fails to delete template with dependencies (FK error raised)' do
    expect {
      delete "/templates/#{template.id}"
    }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  it 'rejects invalid turma update' do
    patch "/turmas/#{turma.id}", params: { turma: { codigo_sigaa: '' } }
    expect(response.status).to satisfy { |s| [400, 422].include?(s) }
  end

  it 'deletes turma' do
    t = Turma.create!(codigo_sigaa: 'TST11', nome: 'X', disciplina: 'Y', semestre: '2/2025', ano: 2025)
    expect { delete "/turmas/#{t.id}" }.to change(Turma, :count).by(-1)
  end

  it 'rejects invalid questao update' do
    patch "/questaos/#{questao.id}", params: { questao: { texto: '' } }
    expect(response.status).to satisfy { |s| [400, 422].include?(s) }
  end

  it 'deletes questao' do
    q = Questao.create!(texto: 'Del', tipo: 'objetiva', template: template)
    expect { delete "/questaos/#{q.id}" }.to change(Questao, :count).by(-1)
  end

  it 'rejects invalid student update' do
    patch "/students/#{student.id}", params: { student: { name: '' } }
    expect(response.status).to satisfy { |s| [400, 422].include?(s) }
  end

  it 'deletes student' do
    s = Student.create!(name: 'Del', email: 'd@ex.com', matricula: 'MD', turma: turma)
    expect { delete "/students/#{s.id}" }.to change(Student, :count).by(-1)
  end

  it 'rejects invalid formulario update' do
    patch "/formularios/#{form.id}", params: { formulario: { turma_id: nil } }
    expect(response.status).to satisfy { |s| [400, 422].include?(s) }
  end

  it 'deletes formulario and its respostas' do
    f = Formulario.create!(titulo: 'FD', data_inicio: DateTime.now, data_termino: DateTime.now + 1.day, template: template, turma: turma)
    Respostum.create!(user: admin, formulario: f, data_resposta: '{"q1":"b"}')
    expect { delete "/formularios/#{f.id}" }.to change(Formulario, :count).by(-1).and change(Respostum, :count).by(-1)
  end

  it 'rejects invalid resposta update' do
    patch "/respostas/#{resp.id}", params: { respostum: { user_id: nil } }
    expect(response.status).to satisfy { |s| [400, 422].include?(s) }
  end

  it 'deletes resposta' do
    r = Respostum.create!(user: admin, formulario: form, data_resposta: '{"q1":"c"}')
    expect { delete "/respostas/#{r.id}" }.to change(Respostum, :count).by(-1)
  end
end
