class Document < ActiveRecord::Base
  has_paper_trail

  attr_accessible :asset, :documentable_id, :documentable_type
  validates_attachment_presence :asset

  has_attached_file :asset, url:
    Rails.application.config.action_controller.relative_url_root.to_s +
    "/system/:class/:attachment/:id_partition/:style/:filename"

  belongs_to :documentable, polymorphic: true

  def polymorphic?
    true
  end

  def parent
    documentable
  end

  # Est-ce une image ?
  def image?
    !(asset_file_name =~ /\.(png|jpe?g|gif)\Z/).nil?
  end

  def to_s
    asset_file_name
  end
end
