require 'rails_helper'

# Testes do model User
RSpec.describe User, type: :model do
  
  # Testa associações
  it { should have_many(:templates) }
  # it { should have_many(:respostas) } # Comentado - associação não definida no model
  
  # Testa validações
  it { should validate_presence_of(:nome) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:matricula) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:matricula) }
  
  describe 'criação de usuário' do
    context 'com dados válidos (Happy Path)' do
      it 'cria usuário válido' do
        user = User.new(email: 'test@example.com', password: '123456', nome: 'Test User', tipo: 'aluno', matricula: '111111')
        expect(user).to be_valid
      end
      
      it 'cria professor válido' do
        user = User.new(email: 'prof@example.com', password: '123456', nome: 'Professor', tipo: 'professor', matricula: '222222')
        expect(user).to be_valid
        expect(user.tipo).to eq('professor')
      end
    end
    
    context 'com dados inválidos (Sad Path)' do
      it 'não cria usuário sem nome' do
        user = User.new(email: 'test@example.com', password: '123456', tipo: 'aluno', matricula: '111111')
        expect(user).not_to be_valid
        expect(user.errors[:nome]).to include("can't be blank")
      end
      
      it 'não cria usuário sem email' do
        user = User.new(nome: 'Test User', password: '123456', tipo: 'aluno', matricula: '111111')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end
      
      it 'não permite email duplicado' do
        User.create!(email: 'test@example.com', password: '123456', nome: 'User 1', tipo: 'aluno', matricula: '111111')
        user2 = User.new(email: 'test@example.com', password: '123456', nome: 'User 2', tipo: 'aluno', matricula: '222222')
        expect(user2).not_to be_valid
        expect(user2.errors[:email]).to include("has already been taken")
      end
    end
  end

  describe 'autenticação' do
    let!(:user) { User.create!(email: 'test@example.com', password: '123456', nome: 'Test User', tipo: 'aluno', matricula: '111111') }
    
    context 'com senha correta (Happy Path)' do
      it 'autentica com sucesso' do
        expect(user.authenticate('123456')).to eq(user)
      end
    end
    
    context 'com senha errada (Sad Path)' do
      it 'não autentica' do
        expect(user.authenticate('senha_errada')).to be false
      end
    end
  end
end