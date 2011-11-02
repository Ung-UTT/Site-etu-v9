class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_layout_vars, :set_locale
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => I18n.t('c.application.denied') +
      " (#{exception.subject.to_s}##{exception.action.to_s})"
  end

  private
    def set_locale
      # ?locale=… ou dans HTTP_ACCEPT_LANGUAGE ou :fr par défaut
      I18n.locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end

    def set_layout_vars
      @random_quote = Quote.random || Quote.new
      @assos = Asso.all
    end

    def current_user
      @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end

    def find_polymorphicable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
end
