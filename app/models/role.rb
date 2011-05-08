class Role < ActiveRecord::Base
  belongs_to :association
  has_and_belongs_to_many :users

  # Enléve le rôle supprimé aux utilisateurs
  before_destroy do self.users.delete_all end
end
