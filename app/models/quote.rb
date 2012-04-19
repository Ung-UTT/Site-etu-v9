class Quote < ActiveRecord::Base
  TAGS = %w(all wikipedia quote tip joke)

  paginates_per 30

  attr_accessible :content, :tag
  validates_presence_of :content
  validates :tag, :inclusion => {:in => Quote::TAGS}

  has_paper_trail

  has_many :comments, :as => :commentable, :dependent => :destroy
end
