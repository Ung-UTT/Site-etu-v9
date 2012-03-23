class Quote < ActiveRecord::Base
  TAGS = %w(all quotes tooltips jokes none)

  paginates_per 30

  validates_presence_of :content
  validates :tag, :inclusion => {:in => Quote::TAGS}

  has_paper_trail

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
end
