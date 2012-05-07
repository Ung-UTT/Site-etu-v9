class News < ActiveRecord::Base
  paginates_per 5

  attr_accessible :title, :content, :event_id, :is_moderated
  validates_presence_of :title

  has_paper_trail

  belongs_to :event
  belongs_to :user
  has_many :documents, :as => :documentable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  class << self
    def visible
      where(is_moderated: true).order('created_at DESC')
    end
  end

  def to_s
    title
  end
end
