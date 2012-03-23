class Comment < ActiveRecord::Base
  validates_presence_of :content

  has_paper_trail

  belongs_to :user
  belongs_to :commentable, :polymorphic => true
end
