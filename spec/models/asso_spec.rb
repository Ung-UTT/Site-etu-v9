require 'spec_helper'

describe Asso do
  before do
    @asso = create :asso
  end

  describe "#users" do
    it "does not return multiple instances of the same user" do
      user = create :user
      %w(member secretary).each { |role| @asso.add_user user, role }
      @asso.users.count(user).should == 1
    end

    it "returns all users with a role" do
      user1 = create :user
      user2 = create :user
      user3 = create :user

      @asso.add_user user1, :member
      @asso.add_user user1, :kikoo
      @asso.add_user user2, :member
      @asso.add_user user3, :secretary

      [user1, user2, user3].each { |u| @asso.users.should include u }
    end

    it "includes the owner once" do
      owner = @asso.owner
      @asso.add_user owner, :boss
      @asso.users.count(owner).should == 1
    end
  end

  it "can add a new member" do
    user = create :user
    @asso.add_user user, :member
    @asso.users.should include user
    @asso.has_user?(user, :member).should be_true
  end

  it "can remove a member" do
    user = create :user
    @asso.add_user user, :member
    @asso.reload.users.should include user
    @asso.has_user?(user, :member).should be_true
    @asso.reload.remove_user user, :member
    @asso.users.should_not include user
    @asso.has_user?(user, :member).should be_false
  end

  it "can have nested assos" do
    club = create(:asso, parent: @asso)
    club.parent.should == @asso
    @asso.children.should include club
  end

  it 'describe itself correctly' do
    asso = build :asso
    asso.to_s.should include asso.name
  end
end

