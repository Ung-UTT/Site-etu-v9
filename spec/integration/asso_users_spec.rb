require 'spec_helper'

feature "Displaying an asso's page" do
  background do
    @asso = create :asso
    @login, @password = 'toto', 'superpass'
    @user = create :student, login: @login, password: @password

    sign_in @login, @password
    visit asso_path(@asso)
  end

  scenario "Joining/disjoining an asso" do
    actions = [join_asso_path(@asso), disjoin_asso_path(@asso)]
    roles = %w(member treasurer)

    actions.each do |action|
      roles.each do |role|
        form = find("//form[@action=\"#{action}\"]")
        within(form) do
          find(".//option[@value=\"#{role}\"]").select_option
          find('.//input[@type="submit"]').click
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

