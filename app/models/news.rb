class News < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 5

  validates_presence_of :title
  validates_associated :user

  belongs_to :user
  belongs_to :event
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
