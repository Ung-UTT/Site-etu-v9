require 'spec_helper'

describe Quote do
  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  it 'describe itself correctly' do
    quote = build :quote
    quote.to_s.include?(quote.content).should be_true
  end
end
