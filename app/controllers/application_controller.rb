class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization

  before_filter :set_layout_vars, :set_locale
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => I18n.t('ability.denied')
  end

  private
    def set_locale
      # ?locale=… ou dans HTTP_ACCEPT_LANGUAGE ou :fr par défaut
      I18n.locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end

    def set_layout_vars
      @user_session = UserSession.new
      @random_quote = Quote.random || Quote.new
      @associations = Association.all
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def current_news
      News.accessible_by(current_ability).page(params[:page])
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
