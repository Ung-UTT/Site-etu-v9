namespace :db do
  desc "Insert fake data for testing (development env only)"
  task fill: :environment do
    raise unless Rails.env.development?
    %w(administrator moderator).each do |login|
      user = User.simple_create(login, 'changez-moi')
      user.add_role login
    end
  end
end

