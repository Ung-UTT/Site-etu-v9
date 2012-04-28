def sign_in login, password
  visit new_user_session_path
  page.should_not have_xpath('//a[@href="/logout"]')

  within(:xpath, '//form[@action="/users/sign_in"]') do
    fill_in 'user_login', with: login
    fill_in 'user_password', with: password
    find(:xpath, './/input[@type="submit"]').click
  end
end

