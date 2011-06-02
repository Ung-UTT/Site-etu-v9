class Course < ActiveRecord::Base
  validates_presence_of :name
  validates_associated :user

  belongs_to :owner, :class_name => 'User'
  has_many :timesheets, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :documents, :as => :documentable, :dependent => :destroy
end
