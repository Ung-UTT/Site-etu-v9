class Annal < ActiveRecord::Base
  belongs_to :course
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
end
