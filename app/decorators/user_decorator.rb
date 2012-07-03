class UserDecorator < Draper::Base
  decorates :user

  def birth_date
    "#{l(user.birth_date)} (#{user.age} #{h.t('years_old')})" if user.birth_date
  end

  def to_s
    if user.firstname.nil? and user.lastname.nil?
      user.login
    else
      "#{user.firstname} #{user.lastname}"
    end
  end

  def link options = {}
    html = h.image_tag(image, class: 'user', alt: to_s)
    html = h.link_to(html, user, title: to_s) if h.can? :read, user

    html
  end

  def image
    user.image.nil? ? 'others/nophoto.png' : user.image.asset.url
  end

  def phone
    unless user.phone.blank?
      h.mobile? ? "#{user.phone} (#{phone_links})".html_safe : user.phone
    end
  end

  def phone_links
    h.link_to(h.t('users.call'), "tel:#{user.phone}") << ', ' <<
    h.link_to(h.t('users.sms'), "sms:#{user.phone}")
  end
end
