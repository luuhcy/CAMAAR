require 'rails_helper'

RSpec.describe Turma, type: :model do
  # Testa se turma é válida
  it 'cria turma válida' do
    turma = Turma.new(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '1º/2024')
    expect(turma).to be_valid
  end

  # Testa validações obrigatórias
  it 'não aceita turma sem código' do
    turma = Turma.new(nome: 'Turma A', semestre: '1º/2024')
    expect(turma).not_to be_valid
  end

  # Testa regra de negócio principal
  it 'permite mesmo código em semestres diferentes' do
    Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '1º/2024')
    turma2 = Turma.new(codigo_sigaa: 'CIC001', nome: 'Turma B', semestre: '2º/2024')
    expect(turma2).to be_valid
  end

  it 'não permite mesmo código no mesmo semestre' do
    Turma.create!(codigo_sigaa: 'CIC001', nome: 'Turma A', semestre: '1º/2024')
    turma2 = Turma.new(codigo_sigaa: 'CIC001', nome: 'Turma B', semestre: '1º/2024')
    expect(turma2).not_to be_valid
  end
end