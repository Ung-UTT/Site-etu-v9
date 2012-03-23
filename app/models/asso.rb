class Asso < ActiveRecord::Base
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

  after_create do create_member end

  # Crée un rôle de membre à la créationde l'asso
  def create_member
    Role.create(:name => 'member', :asso_id => self.id)
  end

  # Rôle membre spécifique à cette association (chaque association a un rôle membre)
  # Si le rôle membre a été supprimé, on le re-crée
  def member
    roles.select { |r| r.name == 'member' }.first || Role.create(:name => 'member', :asso => self)
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
