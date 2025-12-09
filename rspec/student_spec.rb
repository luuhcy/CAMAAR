require 'rails_helper'

# Testes do model Student
RSpec.describe Student, type: :model do
  # Turma é opcional
  it { should belong_to(:turma).optional }

  # Campos obrigatórios
  it { should validate_presence_of(:matricula) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
end
