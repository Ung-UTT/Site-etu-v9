role_admin = Role.create(name: 'admin')
role_moderator = Role.create(name: 'moderator')

admin = User.create(login: 'admin', password: 'changez-moi', email: 'admin@exmaple.com')
moderator = User.create(login: 'moderator', password: 'changez-moi', email: 'moderator@exmaple.com')

admin.roles << role_admin
admin.save

moderator.roles << role_moderator
moderator.save
