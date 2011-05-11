class Course < ActiveRecord::Base
  validates_presence_of :name
  validates_associated :user

  belongs_to :owner, :class_name => 'User'
  has_and_belongs_to_many :users
  has_many :comments, :as => :commentable, :dependent => :destroy
end
