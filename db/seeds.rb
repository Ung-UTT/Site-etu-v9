role_superAdmin = Role.create(:name => 'SuperAdministrateur')
role_admin = Role.create(:name => 'Administrateur')
role_moderator = Role.create(:name => 'Modérateur')

superAdmin = User.create(:login => 'superAdmin', :email => 'superAdmin@etu.utt.fr',
                         :password => 'changez-moi', :password_confirmation => 'changez-moi')

admin = User.create(:login => 'admin', :email => 'admin@etu.utt.fr',
                    :password => 'changez-moi', :password_confirmation => 'changez-moi')

moderator = User.create(:login => 'moderator', :email => 'moderator@etu.utt.fr',
                        :password => 'changez-moi', :password_confirmation => 'changez-moi')

superAdmin.roles << role_superAdmin
superAdmin.save

admin.roles << role_admin
admin.save

moderator.roles << role_moderator
moderator.save
