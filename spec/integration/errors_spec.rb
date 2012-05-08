require 'spec_helper'

feature "Doing nasty stuff" do
  scenario "Browsing to a 404" do
    visit '/phpMyAdmin/lol_im_a_bot'

    page.should have_xpath('//img[@alt="404"]')
  end

  scenario "Accessing users as an anonymous" do
    visit users_path

    page_should_have_alert
    current_path.should == new_user_session_path
  end

  scenario "Accessing annals as a non-student" do
    user = create :user
    sign_in user.login, user.password

    visit courses_path

    page_should_have_alert
    current_path.should == root_path
  end
end

