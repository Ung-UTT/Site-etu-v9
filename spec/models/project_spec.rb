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

  it 'describe itself correctly' do
    project = build :project
    project.to_s.include?(project.name).should be_true
  end
end
