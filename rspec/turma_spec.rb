require 'rails_helper'

RSpec.describe Turma, type: :model do
  describe 'associations' do
    it { should have_many(:students) }
    it { should have_many(:formularios) }
  end

  describe 'validations' do
    it { should validate_presence_of(:codigo_sigaa) }
    it { should validate_presence_of(:semestre) }
  end

  describe '#set_ano_from_semestre' do
    it 'extracts year from semestre' do
      turma = Turma.create(codigo_sigaa: 'ABC123', semestre: '2024.1/2024')
      expect(turma.ano).to eq(2024)
    end
  end
end
