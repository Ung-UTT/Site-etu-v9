role_admin = Role.create(:name => 'admin')
role_moderator = Role.create(:name => 'moderator')

admin = User.simple_create('admin', 'changez-moi')
moderator = User.simple_create('moderator', 'changez-moi')

admin.roles << role_admin
admin.save

moderator.roles << role_moderator
moderator.save
