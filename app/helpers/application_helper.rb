# encoding: UTF-8

module ApplicationHelper
  # Titre de la page

  # Définit quel va être le titre de la page
  # Retourne un titre <h1> qui peut être affiché
  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options.merge(class: 'title'))
  end

  # Titre utilisé dans le layout
  def title_tag
    content_tag(:title, content_for(:title).empty? ? t('helpers.title') : content_for(:title))
  end

  # Raccourcis pour les vues

  # <dd> conditionnelle à ce que ce qui est montré n'est pas vide
  def not_empty_dd(descr, value)
    return nil if value.blank?
    "<dt>#{h(descr)}</dt><dd>#{h(value)}</dd>".html_safe
  end

  # Affichage conditionnelle à ce que ce qui est montré n'est pas vide
  def not_empty_inline(descr, value)
    return nil if value.blank?
    " <strong>#{h(descr)}</strong> : #{h(value)} ".html_safe
  end

  # Select options
  def parent_select_options(name)
    options_for_select(
      nested_set_options(name) do |object|
         "#{'..' * object.level} #{object.to_s}"
      end.unshift([t('helpers.noparent'), nil])
    )
  end

  # General select : need the objects that can be selected
  # And optionnaly the selected objects
  # And also optionnaly if the user can select no objects
  def select_objects(objects, selected = [], none = false)
    objects = objects.map { |object| [object.to_s, object.id] }
    objects.unshift([t('helpers.none'), nil]) if none

    selected = [selected] if selected.class != Array
    selected = selected.compact.map(&:id)

    options_for_select(objects, selected)
  end

  # List of objects (use to #to_s method)
  # Can be inline or in a list
  def links_to_objects(objects, list = false)
    if objects.empty?
      t('helpers.none')
    else
      if list
        content_tag(:ul) do
          objects.map do |object|
            content_tag(:li, link_to(object.to_s, object))
          end
        end
      else
        objects.map { |object| link_to object.to_s, object }.join(', ').html_safe
      end
    end
  end

  # Button to delete a ressource (with confirmation
  def button_to_delete(label, link)
    button_to label, link, confirm: t('common.confirm'), method: :delete
  end
end
