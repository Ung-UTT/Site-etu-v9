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
      nested_set_options(name) do |i|
        asso = i.parent ? "(#{i.parent.name})" : ''
        "#{'..' * i.level} #{i.name} #{asso}"
      end.unshift(["Pas de parent", nil])
    )
  end

  def comment_path(comment)
    return [comment.commentable, comment]
  end

  def list_of(descr, objects, attr, comments=false)
    if objects.empty?
      return nil
    else
      res = '<strong>' + h(descr) + '</strong> :'
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
      # TODO: Ajouter les liens vers les pages des tags
      return content.tags.map(&:name).join(' ').html_safe
    end
  end
end
