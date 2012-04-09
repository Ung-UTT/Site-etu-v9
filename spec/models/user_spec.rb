require 'spec_helper'

describe User do
  describe 'validations' do
    it { should_not allow_value('bla').for(:email) }
    it { should_not allow_value('bla@bla').for(:email) }
    it { should allow_value('bla@bla.bla').for(:email) }

    it 'should reject incorrect confirmation password' do
      user = build :user
      user.password_confirmation = 'bad password'
      user.should be_invalid
    end
  end

  describe 'Methods' do
    before do
      @user ||= create(:user)
    end

    it 'should authentificate a correct user' do
      User.authenticate(@user.login, '').should == nil
      User.authenticate(@user.login, @user.password).should == @user
    end

    it 'should have token and preference' do
      @user.auth_token.should_not be_nil
      @user.preference.should_not be_nil
    end

    it 'should have many assos and courses' do
      @user.assos.should == []
      @user.courses.should == []
    end

    it 'should correctly respond for abilities' do
      @user.is_member_of?(:fake_asso).should be_false
      @user.is?(:fake_role).should be_false
    end
  end
end
