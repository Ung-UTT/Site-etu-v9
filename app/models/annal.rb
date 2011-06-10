class Annal < ActiveRecord::Base
  paginates_per 50

  validates_presence_of :name
  validates_associated :documents

  has_paper_trail
  acts_as_taggable

  belongs_to :course
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
end
