require 'rails_helper'

# Testes da classe base ApplicationRecord
RSpec.describe ApplicationRecord, type: :model do
  describe 'herança' do
    it 'é uma subclasse de ActiveRecord::Base' do
      expect(ApplicationRecord.superclass).to eq(ActiveRecord::Base)
    end
  end

  describe 'funcionalidade básica' do
    it 'é uma classe abstrata' do
      expect(ApplicationRecord.abstract_class).to be true
    end
  end
end