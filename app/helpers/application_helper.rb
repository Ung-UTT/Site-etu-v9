# encoding: UTF-8

module ApplicationHelper
  # Title

  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    content_tag(:h1, page_title, options.merge(:class =>'title'))
  end

  def title_tag
    content_tag(:title, content_for(:title).empty? ? "Site étudiant de l'UTT" : content_for(:title))
  end

  # Select options

  def parent_select_options(name)
    options_for_select(
      nested_set_options(name) do |i|
        if name == Wiki
          "#{'..' * i.level} #{i.title}"
        elsif name == Asso
          asso = i.parent ? "(#{i.parent.name})" : ''
          "#{'..' * i.level} #{i.name} #{asso}"
        elsif name == Role
          "#{'..' * i.level} #{i.name_with_asso}"
        else
          "???"
        end
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
    options_for_select(User.all.map { |a| [a.real_name, a.id] }, default)
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
      if user.ldap_attributes.nil?
        link_to user.login, user
      else
        link_to user, :title => user.ldap_attributes['displayname'] do
          image_tag(user.ldap_attributes['jpegphoto'], :class => 'user')
        end
      end
    else
      user.real_name
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

  def button_to_delete(label, link)
    button_to label, link, :confirm => t('common.confirm'), :method => :delete
  end

  def delete_button(content, object)
    form_for(object, :method => :delete, :html => {:class => 'button_to'}) do |f|
      f.error_messages

      button_tag content, :confirm => t('common.confirm')
    end
  end

  # Emploi du temps

  # Traduit une suite de paramètres en un hash prêt à être utilisé
  # object est l'objet vers lequel on va lié la case qui l'affiche
  def event_to_json(hash)
    return {
      'title' => h(hash['title']),
      'start' => hash['start_at'].iso8601,
      'end' => hash['end_at'].iso8601,
      'url' => url_for(hash['object']),
      'allDay' => hash['allDay'],
      'color' => hash['color'],
    }
  end

  # Passe de ["MATH01", "LE08", ...] à :
  # {"MATH01" => "#231233", "LE08" => "#981822", ...}
  def map_courses_to_colors(courses)
    # Couleurs différentes, foncées
    colors = ['#343D91', '#346F91', '#34916D', '#349143', '#599134',
              '#899134', '#916734', '#914034', '#913457', '#91347E',
              '#7B3491']

    # On va associer à chaque cours une couleur
    i = 0
    hash = Hash.new # Va contenir les couples "UV" => "#couleur"
    courses.each do |name|
      hash.update({name => colors[i]})
      i = (i+1) % colors.size # Ca va au début si ya trop de cours différents
    end
    return hash.update({'_default' => '#6579C5'})
  end

  # Les horaires
  def timesheets_to_json(timesheets)
    agenda = []
    agenda = timesheets.map {|ts| ts.to_fullcalendar}
    return agenda_to_json(agenda)
  end

  def agenda_to_json(array_of_hash)
    agenda = []

    # Les cours
    courses = array_of_hash.map {|hash| hash['course']}.compact.uniq
    # Une couleur est associée à chaque cours
    colors = map_courses_to_colors(courses)

    # On remplit l'emploi du temps selon les normes de FullCalendar
    array_of_hash.map do |hash|
      hash.update({'color' => colors[hash['course'] || '_default']})
      object = event_to_json(hash)
      agenda.push(object)
    end

    return agenda.to_json.html_safe
  end

  def start_date_of_semester
    date = SEMESTERS.last['start_at']
    return {'year' => date.year,
            'month' => date.month - 1,
            'day' => date.day}.to_json.html_safe
  end

  def dates_translations
    dates = {
      'monthNames' => I18n.t('date.month_names').compact, # Enléve le 'nil'
      'monthNamesShort' => I18n.t('date.abbr_month_names').compact,
      'dayNames' => I18n.t('date.day_names'),
      'dayNamesShort' => I18n.t('date.abbr_day_names'),
    }

    return dates.to_json.html_safe
  end
end
