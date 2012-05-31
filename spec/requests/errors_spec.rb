require 'spec_helper'

feature "Doing nasty stuff" do
  scenario "Browsing to a 404" do
    visit '/phpMyAdmin/lol_im_a_bot'

    page.should have_xpath('//img[@alt="404"]')
  end

  scenario "Accessing users as an anonymous" do
    visit users_path

    current_path.should_not == users_path
  end

  scenario "Accessing annals as a non-student" do
    user = create :user
    sign_in user.login, user.password

    visit annals_path

    current_path.should_not == annals_path
  end
end
