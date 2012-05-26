class Quote < ActiveRecord::Base
  TAGS = %w(all quote tip joke)

  paginates_per 30
  has_paper_trail

  attr_accessible :content, :tag, :author
  validates_presence_of :content
  validates :tag, inclusion: {in: Quote::TAGS}

  default_scope order: 'content'

  def to_s
    content
  end
end
