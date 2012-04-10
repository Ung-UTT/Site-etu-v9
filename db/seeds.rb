%w(admin moderator).each do |login|
  unless User.find_by_login(login)
    user = User.simple_create(login, 'changez-moi')
    role = Role.create!(name: login) unless role = Role.find_by_name(login)
    user.roles << role
    user.save!
  end
end

