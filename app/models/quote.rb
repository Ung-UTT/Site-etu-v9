class Quote < ActiveRecord::Base
  TYPES = %w(all quotes tooltips jokes none)

  paginates_per 30

  validates_presence_of :content
  validates :tag, :inclusion => {:in => Quote::TYPES}

  has_paper_trail

  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
end
