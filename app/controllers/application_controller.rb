# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_layout_vars, :set_locale
  helper_method :'mobile?', :current_user_session, :current_user
  layout :which_layout # Chosit le layout normal ou mobile

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => I18n.t('c.application.denied') +
      " (#{exception.subject.to_s}##{exception.action.to_s})"
  end

  rescue_from ActiveRecord::RecordNotFound, :with => :render_record_not_found

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
        http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
        http_accept_language ||= '' # Quand HTTP_ACCEPT_LANGUAGE n'est pas défini (console, ...)

        # Cookie ou dans HTTP_ACCEPT_LANGUAGE ou :fr par défaut
        I18n.locale = cookies[:locale] || http_accept_language.scan(/^[a-z]{2}/).first
      end
    end

    def set_layout_vars
      if current_user
        @random_quote = Quote.where(:tag => current_user.preference.quote_type).random
      end
      @random_quote ||= Quote.random || Quote.new
      @assos = Asso.all
    end

    # Pour gérer les 404 (objet non trouvé ou méthode non trouvée)

    def render_record_not_found
      render :template => "shared/404", :status => 404
    end

    def method_missing(*args)
      render_missing_page
    end

    def render_missing_page
      render :template => "shared/404", :status => 404
    end

    # Méthodes publiques

    def mobile?
      return @is_mobile if defined?(@is_mobile)

      # Si l'utilisateur demande une version particulière, elle prévaut
      if params[:mobile]
        if params[:mobile] == 'true'
          cookies[:force_mobile] = 'true'
          @is_mobile = true
        else
          cookies[:force_mobile] = 'false'
          @is_mobile = false
        end
        return @is_mobile
      end

      # Sinon, on regarde si c'est un téléphone ou si il a déjà choisi une version
      # (Mobile et pas forcé normal) ou force mobile
      if (detect_mobile? and cookies[:force_mobile] != 'false') or cookies[:force_mobile] == 'true'
        @is_mobile = true
      else
        @is_mobile = false
      end

      return @is_mobile
    end

    def which_layout
      mobile? ? 'mobile' : 'application'
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
