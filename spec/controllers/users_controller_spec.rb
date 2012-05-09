require 'spec_helper'

describe UsersController do
  before do
    @user = create :user_with_schedule
  end

  describe "#show" do
    render_views

    it "displays user's schedule properly" do
      sign_in @user
      get :show, id: @user.id
      response.should be_success
    end
  end
end

