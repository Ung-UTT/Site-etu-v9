require 'spec_helper'

describe CasController do
  describe "#new" do
    it 'redirect to the UTT CAS' do
      get :new
      response.should be_redirect
    end

    it 'Add the user if he is new' do
      expect {
        RubyCAS::Filter.fake('new-user')
        get :new
      }.to change{User.count}.by(1)

      User.find_by_login('new-user').should_not be_nil
    end

    it 'Connect the already registered user' do
      create :user, login: "i-was-here"

      expect {
        RubyCAS::Filter.fake('i-was-here')
        get :new
      }.to change{User.count}.by(0)
    end
  end

  describe "#destroy" do
    it 'redirect to the Single Sign Out' do
      get :new
      response.should be_redirect
    end
  end
end
