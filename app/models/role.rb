class Role < ActiveRecord::Base
  # List of special roles not associated to any asso nor parent
  SPECIALS = %w(administrator moderator utt student)

  attr_accessible :name, :asso_id, :parent_id
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:asso_id]
  validates_format_of :name, :with => /\A[a-zA-Z1-9_\- ']+\z/

  has_paper_trail
  # Les rôles peuvent avoir des parents et des enfants (c'est un arbre de roles)
  acts_as_nested_set :dependent => :destroy

  belongs_to :asso

  has_many :wikis, :dependent => :destroy

  has_many :roles_user, :dependent => :destroy
  has_many :users, :through => :roles_user, :uniq => true

  # Enlève le rôle supprimé aux utilisateurs
  before_destroy do self.users.delete_all end

  class << self
    def create_special_role role
      raise "This is not a special role." unless SPECIALS.include? role
      Role.create!(name: role, parent_id: nil, asso_id: nil)
    end

    def get_special_role role
      return nil unless SPECIALS.include? role
      Role.where(name: role, parent_id: nil, asso_id: nil).first
    end

    # Defines shortcuts like Role.utt and so on
    SPECIALS.each do |role|
      define_method role.to_sym do
        get_special_role role
      end
    end
  end

  def name_with_asso
    name + (asso ? " (#{asso.name})" : '')
  end
end

