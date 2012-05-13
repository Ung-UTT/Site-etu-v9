require 'spec_helper'

feature "Logging" do
  background do
    @user = create :user
    @logout_detect = '//form[@action="/users/sign_out"]'
  end

  scenario "Login then logout" do
    sign_in @user.login, @user.password
    current_path.should == '/'
    logout = find(@logout_detect)

    submit_form
    current_path.should == '/'
    page.should_not have_xpath(@logout_detect)
  end

  scenario "Trying to log in with incorrect credentials" do
    sign_in @user.login, @user.password * 2
    current_path.should == '/users/sign_in'
    page.should_not have_xpath(@logout_detect)
  end
end
