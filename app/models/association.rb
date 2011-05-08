class Association < ActiveRecord::Base
  acts_as_nested_set :dependent => :destroy
  belongs_to :president, :class_name => 'User'
  has_many :roles, :dependent => :destroy

  has_many :comments, :as => :commentable, :dependent => :destroy
end
