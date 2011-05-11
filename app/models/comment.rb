class Comment < ActiveRecord::Base
  validates_presence_of :content
  validates_associated :user
  validates_associated :commentable

  belongs_to :commentable, :polymorphic => true

  belongs_to :user
end
