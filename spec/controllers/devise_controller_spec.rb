require 'spec_helper'

describe Devise::SessionsController do
  before do
    @login, @password = 'toto', 'superpass'
    User.simple_create(@login, @password)

    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "POST create" do
    context "with the right credentials" do
      it "can log in" do
        post :create, user: { login: @login, password: @password }
        response.should redirect_to '/'
      end
    end

    context "with incorrect credentials" do
      it "cannot log in" do
        post :create, user: { login: @login, password: @password * 2 }
        response.should_not redirect_to '/'
      end
    end
  end
end

