module UsersHelper
  def link_to_user(user, options = {})
    return nil if user.nil?

    image = user.image.nil? ? 'others/nophoto.png' : user.image.asset.url
    content = image_tag(image, class: 'user', alt: user.to_s)
    link = user.image.asset.url if options[:link_to_asset] and user.image
    link ||= user
    content = link_to(content, link, title: user.to_s) if can? :read, user
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
