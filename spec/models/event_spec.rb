require 'spec_helper'

describe Event do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:owner) }

    it { should have_many(:news) }
    it { should have_many(:comments) }
    it { should have_many(:documents) }
    it { should have_many(:users).through(:events_user) }
    it { should have_many(:assos).through(:assos_event) }
  end
end
