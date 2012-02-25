# encoding: UTF-8

module ApplicationHelper
  def day_names
    I18n.t('date.day_names')
  end

  # Title

  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options.merge(:class =>'title'))
  end

  def title_tag
    content_tag(:title, content_for(:title).empty?  ? "Site étudiant de l'UTT" : content_for(:title))
  end

  # Select options

  def parent_select_options(name)
    options_for_select(
      nested_set_options(name) do |i|
        asso = i.parent ? "(#{i.parent.name})" : ''
        "#{'..' * i.level} #{i.name} #{asso}"
      end.unshift(['Pas de parent', nil])
    )
  end

  def assos_select(object)
    options_for_select(Asso.all.map { |a| [a.name, a.id] }, object.assos.map(&:id))
  end

  def events_select(object)
    default = object.event ? object.event.id : nil
    options_for_select(Event.all.map { |a| [a.name, a.id] }.unshift(['Aucun', nil]), default)
  end

  def course_select(object)
    default = object.course ? object.course.id : nil
    options_for_select(Course.all.map { |a| [a.name, a.id] }.unshift(['Aucun', nil]), default)
  end

  def users_select(object = nil)
    default = object.nil? ? nil : object.users.map(&:id)
    options_for_select(User.all.map { |a| [a.login, a.id] }, default)
  end

  def week_select(object)
    options_for_select([nil, 'A', 'B'], object.week)
  end

  def day_select(object)
    options_for_select(day_names.map {|d| [d, day_names.index(d)]}, day_names[object.day])
  end

  # Links to

  def comment_path(comment)
    return [comment.commentable, comment]
  end

  def list_of(descr, objects, attr, comments=false)
    if objects.empty?
      return nil
    else
      res = '<p><strong>' + h(descr) + '</strong> :</p>' unless descr.empty?
      res += '<ul>'
      objects.each do |object|
        content = object.send(attr)
        if comments
          object = [object.commentable, object]
        end
        res += '<li>' + link_to(h(content), object) + '</li>'
      end
      res += '</ul>'
      return res.html_safe
    end
  end

  def link_to_user(user)
    if can? :read, user
      link_to user.login, user
    else
      user.login
    end
  end

  def link_to_users(users)
    if users.empty?
      return 'Aucun'
    else
      return users.map { |u| link_to_user u}.join(' ').html_safe
    end
  end

  def link_to_assos(object)
    if object.assos.empty?
      return 'Aucune'
    else
      return object.assos.map { |a| link_to a.name, a }.join(' ').html_safe
    end
  end

  # Others

  def courses_when(day, hour, timesheets)
    timesheets.select {|t| t.during?(day, hour)}.map(&:course)
  end

  def button_to_delete(label, link)
    button_to label, link, :confirm => t('common.confirm'), :method => :delete
  end

  def delete_button(content, object)
    form_for(object, :method => :delete, :html => {:class => 'button_to'}) do |f|
      f.error_messages

      button_tag content, :confirm => t('common.confirm')
    end
  end

  def md(text)
    text.nil? ? nil : RDiscount.new(text, :filter_html, :autolink, :no_pseudo_protocols).to_html.html_safe
  end
end
