require 'spec_helper'

describe Carpool do
  describe 'validations' do
    it { should validate_presence_of(:description) }
  end

  it 'describe itself correctly' do
    carpool = build :carpool
    carpool.to_s.include?(carpool.departure.first(10)).should be_true
    carpool.to_s.include?(carpool.arrival.first(10)).should be_true
  end
end
