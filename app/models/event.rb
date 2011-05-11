class Event < ActiveRecord::Base
  validates_presence_of :title
  validates_associated :organizer

  belongs_to :organizer, :class_name => 'User'
  has_and_belongs_to_many :users
  has_many :comments, :as => :commentable, :dependent => :destroy

  # Enléve les participations des utilisateurs à l'événements supprimé
  before_destroy do self.users.delete_all end
end
