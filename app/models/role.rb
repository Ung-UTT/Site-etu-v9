class Role < ActiveRecord::Base
  attr_accessible :name, :asso_id, :parent_id
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:asso_id]
  validates_format_of :name, :with => /\A[a-zA-Z1-9_\- ']+\z/

  has_paper_trail
  # Les rôles peuvent avoir des parents et des enfants (c'est un arbre de roles)
  acts_as_nested_set :dependent => :destroy

  belongs_to :asso

  has_many :roles_user, :dependent => :destroy
  has_many :users, :through => :roles_user, :uniq => true

  # Enlève le rôle supprimé aux utilisateurs
  before_destroy do self.users.delete_all end
end
