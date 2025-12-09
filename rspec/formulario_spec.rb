require 'rails_helper'

# Testes do model Formulario
RSpec.describe Formulario, type: :model do
  # Verifica as associações
  it { should belong_to(:template) }
  it { should belong_to(:turma) }
end
