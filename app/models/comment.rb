class Comment < ActiveRecord::Base
  has_paper_trail

  attr_accessible :content
  validates_presence_of :content

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  def polymorphic?
    true
  end

  def parent
    commentable
  end

  def to_s
    content
  end
end
