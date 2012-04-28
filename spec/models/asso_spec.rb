require 'spec_helper'

describe Asso do
  before do
    @asso = create :asso
  end

  it "can add a new member" do
    user = create :user
    user.add_role :member, @asso
    @asso.users.should include user
  end

  it "can remove a member" do
    user = create :user
    user.add_role :member, @asso
    @asso.users.should include user
    user.remove_role :member, @asso
    @asso.users.should_not include user
  end

  it "can have nested assos" do
    club = create(:asso, parent: @asso)
    club.parent.should == @asso
    @asso.children.should include club
  end
end

