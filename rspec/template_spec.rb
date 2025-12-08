require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:formularios) }
  end
end
