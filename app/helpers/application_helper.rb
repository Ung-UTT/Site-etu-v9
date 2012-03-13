# encoding: UTF-8

module ApplicationHelper
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

  # Links to

  def comment_path(comment)
    return [comment.commentable, comment]
  end

  def list_of(descr, objects, attr, comments=false)
    if objects.empty?
      return nil
    else
      res = ''
      res += '<p><strong>' + h(descr) + '</strong> :</p>' unless descr.empty?
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

  # Variables pour l'emploi du temps

  def array_of_days
    day = DateTime.parse 'Monday'
    res = [day]
    5.times do
      day += 1.day
      res.push(day)
    end
    return res
  end

  def array_of_hours
    hours = []
    (8.hours..22.hours).step(30.minutes) do |h|
      hours.push(Time.at(h.to_i))
    end
    return hours
  end

  # Emploi du temps

  def timesheets_to_json(timesheets)
    schedule = []
    # 13 couleurs différentes, claires
    colors = ['#9696DE', '#96C0DE', '#96DED6', '#96DEB5', '#A0DE96',
              '#BCDE96', '#DEDE96', '#DEBE96', '#DEA396', '#DE96A5',
              '#DE96BE', '#DC96DE', '#BE96DE']
    # Les cours
    names = timesheets.map{|t| t.course.name}.uniq
    # On va associer à chaque cours une couleur
    i = 0
    hash = Hash.new # Va contenir les couples "UV" => "#couleur"
    names.each do |name|
      hash.update({name => colors[i]})
      i = (i+1) % colors.size # Ca va au début si ya trop de cours différents
    end

    # On remplit l'emploi du temps selon les normes de FullCalendar
    timesheets.map do |ts|
      schedule.push({
        'title' => h(ts.short_range),
        'start' => ts.start_at.iso8601,
        'end' => ts.end_at.iso8601,
        'url' => url_for(ts), # Lien vers l'horaire
        'allDay' => false,
        'color' => hash[ts.course.name],
      })
    end

    return schedule.to_json.html_safe
  end

  def start_date_of_semester
    date = SEMESTERS.last['start_at']
    return {'year' => date.year,
            'month' => date.month - 1,
            'day' => date.day}.to_json
  end

  def dates_translations
    dates = {
      'monthNames' => I18n.t('date.month_names').compact, # Enléve le 'nil'
      'monthNamesShort' => I18n.t('date.abbr_month_names').compact,
      'dayNames' => I18n.t('date.day_names'),
      'dayNamesShort' => I18n.t('date.abbr_day_names'),
    }

    return dates.to_json
  end

  # Others

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
    if text.nil?
      return nil
    else
      return RDiscount.new(text, :filter_html, :autolink, :no_pseudo_protocols).to_html.html_safe
    end
  end
end
