require 'spec_helper'

describe News do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:event) }

    it { should have_many(:comments) }
    it { should have_many(:documents) }
  end
end
