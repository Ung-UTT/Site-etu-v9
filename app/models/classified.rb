class Classified < ActiveRecord::Base
  paginates_per 50

  attr_accessible :title, :description, :price, :location, :user_id
  validates_presence_of :title, :description

  has_paper_trail

  belongs_to :user
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
