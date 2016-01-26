class News < ActiveRecord::Base
  paginates_per 5
  has_paper_trail

  validates_presence_of :title

  scope :visible, conditions: {is_moderated: true}

  belongs_to :event
  belongs_to :user
  has_many :documents, as: :documentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  def to_s
    title
  end
end
