require 'spec_helper'

describe Asso do
  describe 'Methods' do
    before do
      @user = FactoryGirl.create(:user)
      @asso = FactoryGirl.create(:asso, :owner => @user)
    end

    it 'should have a member role' do
      @asso.member.should_not be_nil
    end

    it 'can delete user' do
      @asso.member.users.should be_empty
      @asso.users.should be_empty

      @asso.member.users << @user

      @asso.users.first.should == @user
      @asso.member.users.first.should == @user

      @asso.delete_user(@user)

      @asso.member.users.should be_empty
      @asso.users.should be_empty
    end

    it 'can have nested assos' do
      club = FactoryGirl.create(:asso, parent: @asso)

      club.parent.should == @asso
      @asso.children.should include club
    end
  end
end
