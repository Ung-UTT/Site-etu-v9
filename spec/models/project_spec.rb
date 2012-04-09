require 'spec_helper'

describe Project do
  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner) }
    #FIXME: it { should validate_uniqueness_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:owner) }

    it { should have_many(:comments) }
    it { should have_many(:documents) }
    it { should have_many(:users).through(:projects_user) }
  end
end
