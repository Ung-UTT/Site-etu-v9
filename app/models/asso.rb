class Asso < ActiveRecord::Base
  DEFAULT_ROLES = %w[member treasurer secretary]
  resourcify
  paginates_per 32
  has_paper_trail

  # Une asso peut avoir une asso fille (c'est un club)
  acts_as_nested_set dependent: :destroy

  attr_accessible :name, :description, :image, :website, :email, :owner_id, :parent_id
  validates_presence_of :name, :owner
  validates_uniqueness_of :name

  default_scope order: 'name'

  belongs_to :image
  belongs_to :owner, :class_name => 'User'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :documents, as: :documentable, dependent: :destroy

  has_many :assos_event, dependent: :destroy
  has_many :events, through: :assos_event, uniq: true

  include Extensions::Searchable
  searchable_attributes :name, :description

  def users
    # Fetch all users with at least one role on this asso + the owner
    roles.map(&:users).flatten.uniq | [owner]
  end

  def has_user? user, role
    user.has_role? role, self
  end

  def add_user user, role
    user.add_role role, self
  end

  def remove_user user, role
    user.remove_role role, self
  end

  def joinable_roles user
    return [] if user.nil?
    Asso::DEFAULT_ROLES.collect do |role|
      if user.can?(:join, self) and !has_user?(user, role)
        [I18n.t("model.role.roles.#{role}", default: role), role]
      end
    end.compact
  end

  def disjoinable_roles user
    return [] if user.nil?
    roles.map(&:name).collect do |role|
      if user.can?(:disjoin, self) and has_user?(user, role)
        [I18n.t("model.role.roles.#{role}", default: role), role]
      end
    end.compact
  end

  def to_s
    name
  end
end
