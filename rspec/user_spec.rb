require 'rails_helper'

# Testes do model User
RSpec.describe User, type: :model do
  # Associações
  it { should have_many(:templates) }

  # Testa se a senha tá sendo criptografada
  it 'criptografa a senha' do
    user = User.create(email: 'test@example.com', password: 'password123')
    expect(user.password_digest).not_to eq('password123')
    expect(user.authenticate('password123')).to eq(user)
  end
end
