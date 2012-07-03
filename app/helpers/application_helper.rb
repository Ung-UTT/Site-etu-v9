# encoding: UTF-8

module ApplicationHelper

  # Définit quel va être le titre de la page
  # Retourne un titre <h1> qui peut être affiché
  def title(page_title, options = {})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options.merge(class: 'title'))
  end

  # Titre utilisé dans le layout
  def title_tag
    content_tag(:title, content_for(:title).empty? ? t('helpers.title') : content_for(:title))
  end

  # Current path to the RSS feed
  def current_rss(controller)
    controller = 'news' unless controller.in?(%w[events classifieds])
    link = {controller: controller, format: 'rss', only_path: false}
    auto_discovery_link_tag(:rss, link)
  end

  # Raccourcis pour les vues
  def dl(resource, attributes, options = {})
    # resource = resource.model unless resource.is_a? ActiveRecord::Base
    translations = params[:controller] # e.g. users, courses, etc.

    content_tag(:dl,
      attributes.map do |attribute|
        unless (value = resource.__send__(attribute)).blank?
          if value.respond_to?(:link)
            value = value.link
          elsif value.is_a? ActiveRecord::Base
            value = link_to(value.decorator, value)
          elsif value =~ /^https?:\/\//
            value = link_to(value, value)
          end

          content_tag(:dt, t("#{translations}.#{attribute}"), options) <<
          content_tag(:dd, value, options)
        end
      end.join.html_safe
    )
  end

  def dl_inline(resource, attributes, options = {})
    dl resource, attributes, options.merge(class: 'inline')
  end

  # <strong> à condition que ce qui est montré ne soit pas vide
  def not_empty_inline(descr, value, paragraph = false)
    ActiveSupport::Deprecation.warn "ApplicationHelper#not_empty_inline is deprecated, use #dl_inline instead.", caller
    return nil if value.blank?
    res = content_tag(:strong, descr) + " : #{h(value)} ".html_safe
    paragraph ? content_tag(:p, res) : res
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
  # And optionally the selected objects
  # And also optionally if the user can select no objects
  def select_objects(objects, selected = [], none = false)
    objects ||= []
    selected ||= []
    objects = ((selected && objects) || []).map { |object| [object.to_s, object.id] }
    objects.unshift([t('common.none'), nil]) if none

    selected = [selected] unless selected.is_a? Array
    selected = selected.compact.map(&:id)

    options_for_select(objects, selected)
  end

  # List of objects
  # Can be inline or in a list
  def links_to_objects(objects, list = false)
    return content_tag(:p, t('common.none')) if objects.blank?

    links = objects.map do |object|
      if object.respond_to?(:link)
        object.link
      else
        link_to(object.to_s, object)
      end
    end

    if list
      content_tag(:ul) do
        links.map do |link|
          content_tag(:li, link)
        end.join.html_safe
      end
    else
      links.join(', ').html_safe
    end
  end

  # Button to delete a resource (with confirmation)
  def button_to_delete(label, link)
    button_to label, link, data: {confirm: t('common.confirm')}, method: :delete
  end

  # Complete search form
  def search_form(path)
    form_tag(path, method: :get) do
      text_field_tag(:q, params[:q]) + ' ' + submit_tag(t('common.search'))
    end
  end

  # Check if the controller can respond to this action
  def url_exists_for?(action)
    controller = "#{params[:controller]}_controller".classify.constantize
    controller.action_methods.include?(action)
  end

  # Find the current semester and return its name
  def semester_of(date)
    semester = SEMESTERS.detect do |semester|
      date > semester['start_at'] and date < semester['end_at']
    end
    semester ? semester['name'] : '?'
  end
end
