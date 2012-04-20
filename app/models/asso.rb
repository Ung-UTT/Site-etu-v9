class Asso < ActiveRecord::Base
  attr_accessible :name, :description, :image, :owner_id, :parent_id
  validates_presence_of :name, :owner
  validates_uniqueness_of :name

  has_paper_trail
  # Une asso peut avoir une asso fille (c'est un club)
  acts_as_nested_set :dependent => :destroy

  belongs_to :image
  belongs_to :owner, :class_name => 'User'

  has_many :roles, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy

  has_many :assos_event, :dependent => :destroy
  has_many :events, :through => :assos_event, :uniq => true

  after_create :create_member

  # Crée un rôle de membre à la créationde l'asso
  def create_member
    unless roles.map(&:name).include?('member')
      roles << Role.create(:name => 'member')
    end
  end

  # Rôle membre spécifique à cette association (chaque association a un rôle membre)
  def member
    roles.detect { |r| r.name == 'member' }
  end

  # Enlever un utilisateur d'une association
  def delete_user(user)
    roles.each { |r| r.users.delete(user) }
  end

  # Liste des membres de l'associations (ceux qui y ont un rôle)
  def users
    roles.map { |r| r.users }.flatten.uniq
  end
end
