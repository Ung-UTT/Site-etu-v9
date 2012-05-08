require 'spec_helper'

describe Carpool do
  describe 'validations' do
    it { should validate_presence_of(:description) }
  end

  it 'describe itself correctly' do
    carpool = build :carpool
    carpool.to_s.should include carpool.departure.first(10)
    carpool.to_s.should include carpool.arrival.first(10)
  end
end
