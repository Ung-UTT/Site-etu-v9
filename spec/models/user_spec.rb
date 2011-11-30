require 'spec/spec_helper'

describe User do
  fixtures :users

  describe 'Add an user' do
    it 'should accept a correct user' do
      u = User.simple_create('login', 'password')
      u.save.should be_true

      users(:kevin).save.should be_true
    end

    it 'should reject incorrect confirmation password' do
      hash = basic_hash_user
      hash[:password_confirmation] = 'bad password'
      u = User.new(hash)
      u.save.should be_false
    end

    it 'should not allow too same login names' do
      users(:kevin).save
      u = users(:joe)
      u.login = 'kevin'
      u.save.should be_false
    end

    it 'should have all minimum parameters (login, email, pass, pass_conf)' do
      h1 = h2 = h3 = h4 = basic_hash_user
      h1.delete(:login)
      User.new(h1).save.should be_false
      h2.delete(:email)
      User.new(h2).save.should be_false
      h3.delete(:password)
      User.new(h3).save.should be_false
      h4.delete(:password_confirmation)
      User.new(h4).save.should be_false
    end

    it 'should validates email' do
       u = users(:kevin)
       u.email = "not an email"
       u.save.should be_false
       u.email = "almost@an_email"
       u.save.should be_false
       u.email = "an@em.ail"
       u.save.should be_true
    end
  end

  def basic_hash_user
    {:login => 'bla', :email => 'bla@bla.bla',
     :password => 'password', :password_confirmation => 'password'}
  end
end
