module UsersHelper
  def link_to_user(user, options = {})
    ActiveSupport::Deprecation.warn "UsersHelper#link_to_user is deprecated, use UserDecorator#link instead.", caller

    return nil if user.nil?

    UserDecorator.new(user).link
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
