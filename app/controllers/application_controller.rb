class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_layout_vars, :set_locale
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => I18n.t('c.application.denied')
  end

  private
    def set_locale
      # ?locale=… ou dans HTTP_ACCEPT_LANGUAGE ou :fr par défaut
      I18n.locale = params[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end

    def set_layout_vars
      @random_quote = Quote.random || Quote.new
      @associations = Association.all

      @ec_month = (params[:month] || (Time.zone || Time).now.month).to_i
      @ec_year = (params[:year] || (Time.zone || Time).now.year).to_i
      @ec_shown_month = Date.civil(@ec_year, @ec_month)
      @ec_event_strips = Event.event_strips_for_month(@ec_shown_month)
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
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
