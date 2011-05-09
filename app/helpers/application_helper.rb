module ApplicationHelper
  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    return content_tag(:h1, page_title, options)
  end

  def title_tag
    content_tag(:title, content_for(:title).empty?  ? 'Site étu : Le nouveau Face-Twit-Goog-Micro-LinuxFr' : content_for(:title))
  end

  def parent_select_options(name)
    return options_for_select(
      nested_set_options(name) {|i| "#{'..' * i.level} #{i.name}" }.unshift(["Pas de parent", nil])
    )
  end

  def comment_path(comment)
    return [comment.commentable, comment]
  end

  def list_of(descr, objects, attr)
    if objects.empty?
      return nil
    else
      res = '<strong>' + h(descr) + '</strong> :'
      res += '<ul>'
      objects.each do |object|
        res += '<li>' + link_to(object.send(attr), object) + '</li>'
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
      return users.each { |u| link_to_user u}.join ' '
    end
  end
end
