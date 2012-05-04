class Comment < ActiveRecord::Base
  attr_accessible :content
  validates_presence_of :content

  has_paper_trail

  belongs_to :user
  belongs_to :commentable, :polymorphic => true
end
