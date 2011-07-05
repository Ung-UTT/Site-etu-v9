class Document < ActiveRecord::Base
  validates_attachment_presence :asset

  has_paper_trail
  has_attached_file :asset

  belongs_to :documentable, :polymorphic => true

  def image?
    !(asset_file_name =~ /\.(png|jpg|jpeg|gif)$/).nil?
  end
end
