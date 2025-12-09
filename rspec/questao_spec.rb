require 'rails_helper'

# Testes do model Questao
RSpec.describe Questao, type: :model do
  # Associações
  it { should belong_to(:template) }
end
