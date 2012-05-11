require 'spec_helper'

feature "Managing annals" do
  scenario "Creating a new annal" do
    create :course # make sure we have a course
    user = create :administrator

    sign_in user.login, user.password
    visit new_annal_path

    within_form do
      attach_file :annal_documents_attributes_0_asset, file_from_assets('document.pdf').path

      expect {
        submit_form
      }.to change{Annal.count}.by(1)
    end

    current_path.should == annal_path(Annal.last)
    page_should_have_notice
  end
end

