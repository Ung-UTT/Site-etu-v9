class Document < ActiveRecord::Base
  validates_attachment_presence :asset

  has_attached_file :asset
end
