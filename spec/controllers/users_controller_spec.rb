require 'spec_helper'

describe UsersController do
  describe "#index" do
    context "searching users" do
      before do
        @user = create :user, lastname: "Smith"
        sign_in @user
      end

      it "redirects to the user page if he/she is the only result" do
        get :index, q: @user.lastname
        response.should redirect_to(@user)
      end

      it "redirect only if the format is HTML" do
        # Default format is HTML
        get :index, q: @user.lastname, format: 'html'
        response.should be_redirect

        get :index, q: @user.lastname, format: 'json'
        response.should_not be_redirect

        get :index, q: @user.lastname, format: 'xml'
        response.should_not be_redirect
      end

      it "does not redirect if there's more than one result" do
        create :user, lastname: @user.lastname
        get :index, q: @user.lastname
        response.should_not be_redirect
      end
    end
  end

  describe "#show" do
    render_views

    it "displays user's schedule properly" do
      @user = create :user_with_schedule
      sign_in @user

      get :show, id: @user.id
      response.should be_success
    end
  end
end
