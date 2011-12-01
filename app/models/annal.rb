class Annal < ActiveRecord::Base
  paginates_per 50

  validates_presence_of :name

  has_paper_trail

  belongs_to :course
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
end
