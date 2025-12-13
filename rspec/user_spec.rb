require 'rails_helper'

RSpec.describe User, type: :model do
  
  # Testa criação básica
  it 'cria usuário válido' do
    user = User.new(email: 'test@example.com', password: '123456', password_confirmation: '123456')
    expect(user).to be_valid
  end

  # Testa senha
  it 'autentica com senha correta' do
    user = User.create!(email: 'test@example.com', password: '123456')
    expect(user.authenticate('123456')).to eq(user)
  end

  it 'não autentica com senha errada' do
    user = User.create!(email: 'test@example.com', password: '123456')
    expect(user.authenticate('senha_errada')).to be false
  end
end