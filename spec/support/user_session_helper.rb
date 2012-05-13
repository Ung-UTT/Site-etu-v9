def sign_in login, password
  visit new_user_session_path

  within_form do
    fill_in 'user_login', with: login
    fill_in 'user_password', with: password
    submit_form
  end
end
