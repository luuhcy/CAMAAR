require 'rails_helper'

# Testes do model Turma
RSpec.describe Turma, type: :model do
  # Associações
  it { should have_many(:students) }
  it { should have_many(:formularios) }

  # Validações
  it { should validate_presence_of(:codigo_sigaa) }
  it { should validate_presence_of(:semestre) }

  # Testa se extrai o ano do semestre corretamente
  it 'extrai o ano do semestre' do
    turma = Turma.create(codigo_sigaa: 'ABC123', semestre: '2024.1/2024')
    expect(turma.ano).to eq(2024)
  end
end
