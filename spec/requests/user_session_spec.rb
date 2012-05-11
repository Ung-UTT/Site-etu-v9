require 'spec_helper'

feature "Logging in/out" do
  background do
    @user = create :user
  end

  scenario "Logging in then logging out" do
    sign_in @user.login, @user.password
    current_path.should == '/'
    logout = find('//a[@href="/users/sign_out"]')

    logout.click
    current_path.should == '/'
    page.should_not have_xpath('//a[@href="/logout"]')
  end

  scenario "Trying to log in with incorrect credentials" do
    sign_in @user.login, @user.password * 2
    current_path.should == '/users/sign_in'
    page.should_not have_xpath('//a[@href="/logout"]')
  end
end

