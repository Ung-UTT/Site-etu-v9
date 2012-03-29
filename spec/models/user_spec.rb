require 'spec_helper'

describe User do
  fixtures :users

  describe 'Validations' do
    it 'should accept a correct user' do
      User.simple_create('login', 'password').save.should be_true
      users(:kevin).save.should be_true
    end

    it { should validate_uniqueness_of(:login) }
    it { should validate_presence_of(:login) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should_not allow_value('bla').for(:email) }
    it { should_not allow_value('bla@bla').for(:email) }
    it { should allow_value('bla@bla.bla').for(:email) }

    it 'should reject incorrect confirmation password' do
      hash = basic_hash_user
      hash[:password_confirmation] = 'bad password'
      User.new(hash).save.should be_false
    end
  end

  describe 'Associations' do
    it { should have_one(:preference) }

    it { should have_many(:carpools) }
    it { should have_many(:classifieds) }
    it { should have_many(:comments) }
    it { should have_many(:news) }
    it { should have_many(:polls) }
    it { should have_many(:quotes) }
    it { should have_many(:votes) }
    it { should have_many(:created_assos) }
    it { should have_many(:created_events) }
    it { should have_many(:created_projects) }

    it { should have_many(:events).through(:events_user) }
    it { should have_many(:projects).through(:projects_user) }
    it { should have_many(:roles).through(:roles_user) }
    it { should have_many(:timesheets).through(:timesheets_user) }
  end

  describe 'Methods' do
    before(:all) do
      @foo = User.simple_create('foobar', 'password')
    end

    it 'should authentificate a correct user' do
      User.authenticate('foobar', 'not password').should == nil
      User.authenticate('foobar', 'password').should == @foo
    end

    it 'should have token and preference' do
      @foo.auth_token.should_not be_nil
      @foo.preference.should_not be_nil
    end

    it 'should have many assos and courses' do
      @foo.assos.should == []
      @foo.courses.should == []
    end

    it 'should correctly respond for abilities' do
      @foo.is_member_of?(:fake_asso).should be_false
      @foo.is?(:fake_role).should be_false
    end
  end

  def basic_hash_user
    {:login => 'bla', :email => 'bla@bla.bla',
     :password => 'password', :password_confirmation => 'password'}
  end
end
