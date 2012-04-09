require 'spec_helper'

describe Quote do
  describe 'Validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }

    it { should have_many(:comments) }
  end
end
