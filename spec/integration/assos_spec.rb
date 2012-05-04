require 'spec_helper'

feature "Managing an asso" do
  scenario "Creating an asso" do
    user = create :student

    sign_in user.login, user.password
    visit new_asso_path

    form = find("//form[@action=\"/assos\"]")
    within(form) do
      fill_in :name, with: "UNG"

      expect {
        submit_form
      }.to change{Asso.count}.by(1)
    end

    current_path.should == asso_path(Asso.last)
    page_should_have_notice
  end

  scenario "Joining/disjoining an asso" do
    asso = create :asso
    user = create :student

    sign_in user.login, user.password
    visit asso_path(asso)

    actions = [join_asso_path(asso), disjoin_asso_path(asso)]
    roles = %w(member treasurer)

    actions.each do |action|
      roles.each do |role|
        form = find("//form[@action=\"#{action}\"]")
        within(form) do
          find(".//option[@value=\"#{role}\"]").select_option
          submit_form
        end

        if action == actions.last and role == roles.last
          page.should_not have_selector("//form[@action=\"#{action}\"]")
        else
          form = find("//form[@action=\"#{action}\"]")
          form.should_not have_selector(".//option[@value=\"#{role}\"]")
        end
      end
    end
  end
end

