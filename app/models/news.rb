class News < ActiveRecord::Base
  paginates_per 5
  has_paper_trail

  attr_accessible :title, :content, :event_id, :is_moderated
  validates_presence_of :title

  default_scope order: 'created_at DESC'
  scope :visible, conditions: {is_moderated: true}

  belongs_to :event
  belongs_to :user
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def to_s
    title
  end
end
