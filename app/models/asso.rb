class Asso < ActiveRecord::Base
  DEFAULT_ROLES = %w[member treasurer secretary]
  resourcify

  attr_accessible :name, :description, :image, :owner, :parent_id
  validates_presence_of :name, :owner
  validates_uniqueness_of :name

  has_paper_trail
  # Une asso peut avoir une asso fille (c'est un club)
  acts_as_nested_set :dependent => :destroy

  belongs_to :image
  belongs_to :owner, :class_name => 'User'

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  has_many :assos_event, :dependent => :destroy
  has_many :events, :through => :assos_event, :uniq => true

  def to_s
    name
  end

  def users
    # Fetch all users with at least one role on this asso
    user_ids = UsersRole.where(role_id: roles.map(&:id)).map(&:user_id).uniq
    user_ids.collect { |id| User.find id } << owner
  end

  def has_user? user, role
    return false unless role = roles.where(name: role).first
    !UsersRole.where(role_id: role.id, user_id: user.id).empty?
  end

  def add_user user, role
    user.add_role role, self
  end

  def remove_user user, role
    user.remove_role role, self
  end
end
