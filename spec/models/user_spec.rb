require 'spec/spec_helper'

describe User do
  fixtures :users

  describe 'Validations' do
    it 'should accept a correct user' do
      u = User.simple_create('login', 'password')
      u.save.should be_true

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
      u = User.new(hash)
      u.save.should be_false
    end
  end

  describe 'Associations' do
    it { should have_one(:preference) }

    it { should have_many(:carpools) }
    it { should have_many(:classifieds) }
    it { should have_many(:comments) }
    it { should have_many(:news) }
    it { should have_many(:pools) }
    it { should have_many(:quotes) }
    it { should have_many(:reminders) }
    it { should have_many(:votes) }
    it { should have_many(:created_assos) }
    it { should have_many(:created_events) }
    it { should have_many(:created_projects) }

    it { should have_many(:events).through(:events_user) }
    it { should have_many(:groups).through(:groups_user) }
    it { should have_many(:projects).through(:projects_user) }
    it { should have_many(:roles).through(:roles_user) }
    it { should have_many(:timesheets).through(:timesheets_user) }
  end

  def basic_hash_user
    {:login => 'bla', :email => 'bla@bla.bla',
     :password => 'password', :password_confirmation => 'password'}
  end
end
