require 'spec_helper'

describe Group do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should have_many(:users).through(:groups_user) }
  end
end
