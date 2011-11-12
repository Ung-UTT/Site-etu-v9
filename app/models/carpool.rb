class Carpool < ActiveRecord::Base
  validates_presence_of :description
  validates_associated :user

  has_paper_trail

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
end
