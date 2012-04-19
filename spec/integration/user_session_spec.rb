require 'spec_helper'

feature "Logging in/out" do
  background do
    Capybara.default_selector = :xpath
    @login, @password = 'toto', 'oups'
    create :user, login: @login, password: @password
  end

  def log_in_with password
    visit login_path
    page.should_not have_xpath('//a[@href="/logout"]')

    within('//form[@action="/user_sessions"]') do
      fill_in 'login', with: @login
      fill_in 'password', with: password
      find('.//input[@type="submit"]').click
    end
  end

  scenario "Logging in then logging out" do
    log_in_with @password
    current_path.should == '/'
    logout = find('//a[@href="/logout"]')

    logout.click
    current_path.should == '/'
    page.should_not have_xpath('//a[@href="/logout"]')
  end

  scenario "Trying to log in with incorrect credentials" do
    log_in_with ''
    current_path.should == '/user_sessions'
    page.should_not have_xpath('//a[@href="/logout"]')
  end
end

