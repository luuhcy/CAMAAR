require 'rails_helper'

# Testes do model Template
RSpec.describe Template, type: :model do
  # Associações
  it { should belong_to(:user) }
  it { should have_many(:formularios) }
end
