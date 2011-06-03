class Quote < ActiveRecord::Base
  paginates_per 30

  validates_presence_of :content
  validates_associated :user

  has_paper_trail
  acts_as_taggable

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
end
