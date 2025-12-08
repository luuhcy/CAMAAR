require 'rails_helper'

RSpec.describe Questao, type: :model do
  describe 'associations' do
    it { should belong_to(:template) }
  end
end
