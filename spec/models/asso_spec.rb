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
    it { should belong_to(:owner) }

    it { should have_many(:roles) }
    it { should have_many(:comments) }
    it { should have_many(:documents) }
    it { should have_many(:events).through(:assos_event) }
  end

  describe 'Methods' do
    before do
      @a = Asso.create(:name => 'Asso', :owner => users(:kevin))
      @a.save
    end

    it 'should have a member role' do
      @a.member.should_not be_nil
    end

    it 'can delete user' do
      @a.member.users.should be_empty
      @a.users.should be_empty

      @a.member.users << users(:kevin)

      @a.users.first.should == users(:kevin)
      @a.member.users.first.should == users(:kevin)

      @a.delete_user(users(:kevin))

      @a.member.users.should be_empty
      @a.users.should be_empty
    end

    it 'can have nested assos' do
      @b = Asso.new(:name => 'Asso B', :owner => users(:joe), :parent => @a)
      @b.save.should be_true

      @b.parent.should == @a
      @a.children.first.should == @b
    end
  end
end
