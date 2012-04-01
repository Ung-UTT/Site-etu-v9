class Document < ActiveRecord::Base
  validates_attachment_presence :asset

  has_paper_trail
  has_attached_file :asset

  belongs_to :documentable, :polymorphic => true

  # À partir d'une URL, récupérer un fichier utilisable pour créer un
  # document ou une image
  def self.from_url(url)
    extname = File.extname(url)
    basename = File.basename(url, extname)

    file = Tempfile.new([basename, extname])
    file.binmode

    open(URI.parse(url)) do |data|
      file.write data.read
    end

    file.rewind

    return file
  end


  # Est-ce une image ?
  def image?
    !(asset_file_name =~ /\.(png|jpg|jpeg|gif)$/).nil?
  end
end
