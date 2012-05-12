module UsersHelper
  def link_to_user(user)
    return nil if user.nil?

    image = user.image.nil? ? 'others/nophoto.png' : user.image.asset.url
    content = image_tag(image, class: 'user', alt: user.real_name)
    content = link_to(content, user, title: user.real_name) if can? :read, user
    content
  end

  def links_to_users(users)
    if users.empty?
      t('common.none')
    else
      users.map { |u| link_to_user u }.join(' ').html_safe
    end
  end

  def select_locale
    I18n.available_locales.map(&:to_s).map do |locale|
      [ t("locales.#{locale}"), locale ]
    end
  end

  def select_quote_type
    Quote::TAGS.map { |tag| [ t("model.quote.tags.#{tag}"), tag ] }
  end
end
