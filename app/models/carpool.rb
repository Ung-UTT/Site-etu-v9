class Carpool < ActiveRecord::Base
  validates_presence_of :content
  validates_associated :user

  belongs_to :user

  has_many :comments, :as => :commentable, :dependent => :destroy
end
