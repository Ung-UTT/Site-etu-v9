require 'spec_helper'

describe Answer do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:poll) }
  end
end
