class News < ActiveRecord::Base
  paginates_per 5

  validates_presence_of :title

  has_paper_trail

  belongs_to :event
  belongs_to :user
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
