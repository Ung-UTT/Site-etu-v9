class Image < Document
  # On définie une image par son format : jpeg, png, ... etc
  # Niveau sécurité : le content_type n'est pas celui donné par l'utilisateur
  # mais il est deviné par rapport à l'extension
  validates_attachment_content_type :asset, :content_type => [ /^image\/(?:jpeg|gif|png|jpg)$/, nil ]
end
