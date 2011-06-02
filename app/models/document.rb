class Document < ActiveRecord::Base
  validates_attachment_presence :asset

  belongs_to :documentable, :polymorphic => true

  has_attached_file :asset
end
