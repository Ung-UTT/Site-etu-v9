class Classified < ActiveRecord::Base
  validates_presence_of :title, :content
  validates_associated :user

  belongs_to :user

  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
end
