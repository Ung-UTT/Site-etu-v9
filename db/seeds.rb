# Create special roles
Role::SPECIALS.each do |role|
  unless Role.send(role.to_sym)
    Role.create_special_role role
  end
end

