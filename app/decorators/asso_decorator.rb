class AssoDecorator < ApplicationDecorator
  decorates :asso

  def logo
    h.image_tag(asso.image.asset.url) if asso.image
  end

  def description
    h.md asso.description
  end

  def children
    asso.children.map { |child| h.link_to(child, child) }.join(', ').html_safe
  end

  def members
    return if asso.roles.empty?

    h.content_tag(:ul,
      asso.roles.map do |role|
        users = UserDecorator.decorate(role.users)
        h.content_tag(:li, "#{role.name} #{h.links_to_objects(users)}".html_safe)
      end.join.html_safe
    )
  end

  def events
    h.links_to_objects(asso.events)
  end

  def to_s
    name
  end
end
