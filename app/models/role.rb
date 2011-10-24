class Role < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:asso_id]
  validates_format_of :name, :with => /[a-zA-Z1-9_\- ']+/

  # has_paper_trail # TODO: Trouver pourquoi ça ne fonctionne pas
  acts_as_nested_set :dependent => :destroy

  belongs_to :asso
  has_and_belongs_to_many :users, :uniq => true

  # Enlève le rôle supprimé aux utilisateurs
  before_destroy do self.users.delete_all end

  def symbol
    return name.to_sym
  end

  # TODO: Enlever ce workaround
  protected
    def set_default_left_and_right
      Role.unscoped do
        super
      end
    end
end
