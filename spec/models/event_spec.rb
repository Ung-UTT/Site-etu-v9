require 'spec_helper'

describe Event do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  it 'describe itself correctly' do
    event = build :event
    event.to_s.include?(event.name).should be_true
  end
end
