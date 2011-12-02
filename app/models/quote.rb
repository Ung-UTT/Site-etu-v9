class Quote < ActiveRecord::Base
  paginates_per 30

  validates_presence_of :content

  has_paper_trail

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
end
