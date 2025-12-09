require 'rails_helper'

# Testes do model Respostum
RSpec.describe Respostum, type: :model do
  # Testa se as associações tão funcionando
  it { should belong_to(:user) }
  it { should belong_to(:formulario) }
end
