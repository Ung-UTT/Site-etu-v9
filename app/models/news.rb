class News < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy

  scope :descending, order('created_at DESC')
end
