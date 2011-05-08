module ApplicationHelper
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
end
