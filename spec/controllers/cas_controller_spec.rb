require 'spec_helper'

describe CasController do
  describe "#new" do
    it "redirects to the UTT CAS" do
      get :new
      response.should be_redirect
    end

    context "new user" do
      it "creates the user" do
        RubyCAS::Filter.fake('new-user')

        expect {
          get :new
        }.to change{User.count}.by(1)

        User.find_by_login('new-user').should_not be_nil
      end
    end

    context "existing user" do
      it "does not create an user" do
        create :user, login: "i-was-here"
        RubyCAS::Filter.fake('i-was-here')

        expect {
          get :new
        }.to_not change{User.count}
      end
    end
  end

  describe "#destroy" do
    it "redirects to the Single Sign Out" do
      get :destroy
      response.should be_redirect
    end
  end
end
