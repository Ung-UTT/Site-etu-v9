require 'spec_helper'

describe Carpool do
  describe 'Validations' do
    it { should validate_presence_of(:description) }
  end

  describe 'Associations' do
    it { should belong_to(:user) }

    it { should have_many(:comments) }
    it { should have_many(:documents) }
  end
end
