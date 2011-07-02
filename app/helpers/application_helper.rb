# TODO: Néttoyer, réorganiser, toussa…

module ApplicationHelper
  # Title

  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    return content_tag(:h1, page_title, options)
  end

  def title_tag
    content_tag(:title, content_for(:title).empty?  ? 'Site étu : Le nouveau Face-Twit-Goog-Micro-LinuxFr' : content_for(:title))
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

  def associations_select(object)
    options_for_select(Association.all.map { |a| [a.name, a.id] }, object.associations.map(&:id))
  end

  def events_select(object)
    default = object.event ? object.event.id : nil
    options_for_select(Event.all.map { |a| [a.title, a.id] }.unshift(['Aucun', nil]), default)
  end

  def course_select(object)
    default = object.course ? object.course.id : nil
    options_for_select(Course.all.map { |a| [a.name, a.id] }.unshift(['Aucun', nil]), default)
  end

  def users_select(object)
    options_for_select(User.all.map { |a| [a.login, a.id] }, object.users.map(&:id))
  end

  # Links to

  def comment_path(comment)
    return [comment.commentable, comment]
  end

  def list_of(descr, objects, attr, comments=false)
    if objects.empty?
      return nil
    else
      res = descr.empty? ? '' : '<strong>' + h(descr) + '</strong> :'
      res += '<ul>'
      objects.each do |object|
        content = object.send(attr)
        if comments
          object = [object.commentable, object]
        end
        res += '<li>' + link_to(content, object) + '</li>'
      end
      res += '</ul>'
      return res.html_safe
    end
  end

  def link_to_user(user)
    return link_to user.login, user
  end

  def link_to_users(users)
    if users.empty?
      return 'Aucun'
    else
      return users.map { |u| link_to_user u}.join(' ').html_safe
    end
  end

  def link_to_tags(content)
    if content.tags.empty?
      return 'Aucun'
    else
      return content.tags.map{|t| link_to t.name, Tag.find(t.id) }.join(' ').html_safe
    end
  end

  def link_to_associations(object)
    if object.associations.empty?
      return 'Aucune'
    else
      return object.associations.map { |a| link_to a.name, a }.join(' ').html_safe
    end
  end

  # Others

  def find_polymorphicable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

  def each_day
    (0..6.day).step(1.day) do |day|
      yield(Time.at(day) + 4.day)
    end
  end

  def courses_when(day, hour, timesheets)
    timesheets.select {|t| t.during?(Time.at(day.to_i + hour.to_i)) }.map(&:course)
  end
end
