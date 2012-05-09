require 'spec_helper'

describe Devise::SessionsController do
  before do
    @user = create :user

    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "#create" do
    context "with the right credentials" do
      it "can log in" do
        post :create, user: { login: @user.login, password: @user.password }
        response.should redirect_to '/'
      end
    end

    context "with incorrect credentials" do
      it "cannot log in" do
        post :create, user: { login: @user.login, password: @user.password * 2 }
        response.should_not redirect_to '/'
      end
    end
  end
end

