class Association < ActiveRecord::Base
  acts_as_nested_set

  belongs_to :president, :class_name => 'User'

  has_many :comments, :as => :commentable
end
