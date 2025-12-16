require 'rails_helper'

# Testes do model User
RSpec.describe User, type: :model do
  # Associações
  it { should have_many(:templates) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        nome: 'Test User',
        email: 'test@example.com',
        matricula: '123456',
        password: 'password123',
        tipo: 'admin'
      )
      expect(user).to be_valid
    end
    
    it 'is invalid without a nome' do
      user = User.new(nome: nil, email: 'test@example.com', matricula: '123', password: 'pass', tipo: 'admin')
      expect(user).to_not be_valid
    end
    
    it 'is invalid without an email' do
      user = User.new(nome: 'Test', email: nil, matricula: '123', password: 'pass', tipo: 'admin')
      expect(user).to_not be_valid
    end
    
    it 'is invalid with a duplicate email' do
      User.create!(nome: 'User1', email: 'same@example.com', matricula: '111', password: 'pass', tipo: 'admin')
      user2 = User.new(nome: 'User2', email: 'same@example.com', matricula: '222', password: 'pass', tipo: 'admin')
      expect(user2).to_not be_valid
    end
    
    it 'is invalid without a matricula' do
      user = User.new(nome: 'Test', email: 'test@example.com', matricula: nil, password: 'pass', tipo: 'admin')
      expect(user).to_not be_valid
    end
    
    it 'is invalid with a duplicate matricula' do
      User.create!(nome: 'User1', email: 'user1@example.com', matricula: '123456', password: 'pass', tipo: 'admin')
      user2 = User.new(nome: 'User2', email: 'user2@example.com', matricula: '123456', password: 'pass', tipo: 'admin')
      expect(user2).to_not be_valid
    end
  end

  # Testa se a senha tá sendo criptografada
  describe 'password encryption' do
    it 'criptografa a senha' do
      user = User.create(email: 'test@example.com', password: 'password123', nome: 'Test', matricula: '999', tipo: 'admin')
      expect(user.password_digest).not_to eq('password123')
      expect(user.authenticate('password123')).to eq(user)
    end
    
    it 'authenticates with correct password' do
      user = User.create!(nome: 'Test', email: 'test2@example.com', matricula: '888', password: 'mypassword', tipo: 'admin')
      expect(user.authenticate('mypassword')).to eq(user)
    end
    
    it 'does not authenticate with incorrect password' do
      user = User.create!(nome: 'Test', email: 'test3@example.com', matricula: '777', password: 'mypassword', tipo: 'admin')
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end
  
  describe 'tipo field' do
    it 'can be admin' do
      user = User.create!(nome: 'Admin', email: 'admin@example.com', matricula: '666', password: 'pass', tipo: 'admin')
      expect(user.tipo).to eq('admin')
    end
    
    it 'can be student' do
      user = User.create!(nome: 'Student', email: 'student@example.com', matricula: '555', password: 'pass', tipo: 'student')
      expect(user.tipo).to eq('student')
    end
  end
end
