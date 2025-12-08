require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:templates) }
  end

  describe 'password encryption' do
    it 'encrypts password with has_secure_password' do
      user = User.create(email: 'test@example.com', password: 'password123')
      expect(user.password_digest).not_to eq('password123')
      expect(user.authenticate('password123')).to eq(user)
    end
  end
end
