class Classified < ActiveRecord::Base
  paginates_per 50

  validates_presence_of :title, :content
  validates_associated :user

  has_paper_trail
  acts_as_taggable

  belongs_to :user
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
