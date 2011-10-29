class Image < Document
  validates_attachment_content_type :asset, :content_type => [ /^image\/(?:jpeg|gif|png)$/, nil ]
end
