require 'spec_helper'

feature "Managing annals" do
  scenario "Creating a new annal" do
    create :course # make sure we have a course
    login, password = 'toto', 'superpass'
    user = create :administrator, login: login, password: password

    sign_in login, password
    visit new_annal_path

    form = find("//form[@action=\"/annals\"]")
    within(form) do
      attach_file :annal_documents_attributes_0_asset, file_from_assets('document.pdf').path
      submit_form
    end

    current_path.should == annal_path(Annal.last)
    page_should_have_notice
  end
end

