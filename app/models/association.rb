class Association < ActiveRecord::Base
  belongs_to :president, :class_name => 'User'

  has_many :comments, :as => :commentable
end
