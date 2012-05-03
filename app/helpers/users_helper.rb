module UsersHelper
  def link_to_user(user)
    if can? :read, user
      if user.nil?
        ''
      elsif user.image.nil?
        link_to user.real_name, user
      else
        link_to user, title: user.real_name do
          image_tag(user.image.asset.url, class: 'user')
                    alt: user.real_name)
        end
      end
    else
      user.nil? ? '' : user.real_name
    end
  end

  def link_to_users(users)
    if users.empty?
      return t('helpers.none')
    else
      return users.map { |u| link_to_user u}.join(', ').html_safe
    end
  end
end
