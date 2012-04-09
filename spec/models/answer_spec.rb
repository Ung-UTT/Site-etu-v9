require 'spec_helper'

describe Answer do
  describe 'Validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:poll) }
  end

  describe 'Associations' do
    it { should belong_to(:poll) }

    it { should have_many(:votes) }
  end
end
