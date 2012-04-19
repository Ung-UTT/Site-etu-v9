require 'spec_helper'

feature "Doing nasty stuff" do
  scenario "Browsing to a 404" do
    visit '/phpMyAdmin/lol_im_a_bot'
    page.should have_xpath('//img[@alt="404"]')
  end
end

