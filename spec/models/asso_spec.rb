require 'spec_helper'

describe Asso do
  fixtures :assos, :users

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:owner) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:image) }

    it { should have_many(:comments) }
    it { should have_many(:documents) }
  end

  describe 'Methods' do
    it 'should have a member role' do
      a = Asso.create(:name => 'Asso', :owner => users(:kevin))
      a.save
      a.member.should_not be_empty
    end
  end
end
