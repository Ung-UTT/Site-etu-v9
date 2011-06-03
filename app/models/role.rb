class Role < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:association_id]
  validates_format_of :name, :with => /[a-zA-Z1-9_\- ']+/

  has_paper_trail
  acts_as_nested_set :dependent => :destroy

  belongs_to :association
  has_and_belongs_to_many :users, :uniq => true

  # Enléve le rôle supprimé aux utilisateurs
  before_destroy do self.users.delete_all end

  def symbol
    return name.to_sym
  end
end
