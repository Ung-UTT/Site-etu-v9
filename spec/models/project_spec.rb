require 'spec_helper'

describe Project do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner) }
    it {
         create :project
         should validate_uniqueness_of(:name)
   }
  end
end
