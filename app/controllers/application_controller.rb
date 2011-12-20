# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_layout_vars, :set_locale, :set_mobile_format
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => I18n.t('c.application.denied') +
      " (#{exception.subject.to_s}##{exception.action.to_s})"
  end

  private
    def set_locale
      if params[:locale]
        cookies[:locale] = params[:locale]

        if current_user
          current_user.preference.locale = params[:locale]
          current_user.preference.save if current_user.preference.changed?
        end
      end

      if current_user and current_user.preference.locale
        I18n.locale = current_user.preference.locale
      else
        # Cookie ou dans HTTP_ACCEPT_LANGUAGE ou :fr par défaut
        I18n.locale = cookies[:locale] || request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      end
    end

    def set_layout_vars
      if current_user
        @random_quote = Quote.where(:tag => current_user.preference.quote_type).random
      end
      @random_quote ||= Quote.random || Quote.new
      @assos = Asso.all
    end

    def set_mobile_format
      if params[:classic]
        if params[:classic] == 'false'
          cookies[:force_classic] = 'false'
        else
          cookies[:force_classic] = 'true'
        end
      end

      if (detect_mobile? and cookies[:force_classic] != 'true') or cookies[:force_classic] == 'false'
        request.format = :mobile
      end
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
