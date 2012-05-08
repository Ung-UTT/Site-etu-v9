require 'spec_helper'

describe Answer do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:poll) }
  end

  it 'describe itself correctly' do
    answer = build :answer
    answer.to_s.should include answer.content.first(10)
  end
end
