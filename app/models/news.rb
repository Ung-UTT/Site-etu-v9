class News < ActiveRecord::Base
  validates_presence_of :title
  validates_associated :user

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy

  scope :descending, order('created_at DESC')
end
