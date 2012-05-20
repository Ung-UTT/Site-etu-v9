require 'spec_helper'

describe Project do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it {
         create :project
         should validate_uniqueness_of(:name)
    }
  end

  it 'describe itself correctly' do
    project = build :project
    project.to_s.should include project.name
  end
end
