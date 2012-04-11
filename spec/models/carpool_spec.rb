require 'spec_helper'

describe Carpool do
  describe 'validations' do
    it { should validate_presence_of(:description) }
  end
end
