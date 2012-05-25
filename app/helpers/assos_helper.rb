module AssosHelper
  def image_tag_for_asso(asso)
    url = asso.image ? asso.image.asset.url : 'others/asso.png'
    link_to image_tag(url, class: 'asso'), asso
  end
end
