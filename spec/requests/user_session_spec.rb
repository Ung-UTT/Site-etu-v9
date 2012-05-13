require 'spec_helper'

feature "Logging in/out" do
  let(:logout_form) { '//form[@action="/users/sign_out"]' }

  background do
    @user = create :user
  end

  scenario "Logging in then logging out" do
    sign_in @user.login, @user.password
    current_path.should == '/'
    logout = find(logout_form)

    submit_form
    current_path.should == '/'
    page.should_not have_xpath(logout_form)
  end

  scenario "Trying to log in with incorrect credentials" do
    sign_in @user.login, @user.password * 2
    current_path.should == '/users/sign_in'
    page.should_not have_xpath(logout_form)
  end
end
