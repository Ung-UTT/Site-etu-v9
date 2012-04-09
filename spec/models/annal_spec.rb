require 'spec_helper'

describe Annal do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:course) }
    it { should have_many(:comments) }

    it { should have_many(:documents) }
  end
end
