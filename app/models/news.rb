class News < ActiveRecord::Base
  paginates_per 5

  # L'attribut is_moderated est protégé dans le controlleur
  attr_accessible :title, :content, :event_id, :is_moderated
  validates_presence_of :title

  has_paper_trail

  belongs_to :event
  belongs_to :user
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
