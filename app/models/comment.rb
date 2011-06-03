class Comment < ActiveRecord::Base
  validates_presence_of :content
  validates_associated :user
  validates_associated :commentable

  has_paper_trail

  belongs_to :user
  belongs_to :commentable, :polymorphic => true
end
