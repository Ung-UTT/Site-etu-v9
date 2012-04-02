# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  # Permet de récupérer les erreurs et de les traiter
  around_filter :catch_exceptions
  # Permet de définir des variables utiles à toutes les vues
  before_filter :set_layout_vars, :set_locale
  # Méthode que l'on peut utiliser dans les controlleurs et dans les vues
  helper_method :'mobile?', :current_user_session, :current_user, :md
  # Chosit le layout normal ou mobile
  layout :which_layout

  # Gére la prévisualisation du Markdown
  def preview
    render :text => md(params[:data])
  end

  # Gére les erreurs 404
  def render_not_found
    logger.error '[404] ' + request.fullpath
    render :template => "shared/404", :status => 404
  end

  # Gére les accès refusés
  def render_access_denied(exception)
    message = "#{I18n.t('c.application.denied')}"
    message +=" (#{exception.subject.to_s}##{exception.action.to_s})"

    logger.error '[401] ' + request.fullpath + ' | ' + message

    if current_user
      redirect_to root_url, :alert => message
    else
      # Redirige vers la page de login si l'utilisateur n'est pas déjà loggé
      redirect_to login_url, :alert => message
    end
  end

  # Gére les erreurs de code (variable non définie, ... etc)
  def render_error(exception)
    logger.error '[500] ' + request.fullpath + ' | ' + exception.inspect

    # Une explication minimale du problème est fournie
    backtrace = exception.backtrace.first(5)

    render :template => "shared/500", :status => 500,
           :locals => {:exception => exception, :backtrace => backtrace}
  end

  private
    def catch_exceptions
      yield # Exécute le code des controlleurs, vues, etc...

      rescue => exception
        # Erreur 404
        if exception.is_a?(ActiveRecord::RecordNotFound) or
           exception.is_a?(ActionView::MissingTemplate)
          render_not_found
        # Problème de droit
        elsif exception.is_a?(CanCan::AccessDenied)
          render_access_denied(exception)
        else # Autre erreur
          render_error(exception)
        end
    end

    # Pour gérer les 404 (objet non trouvé ou méthode non trouvée)
    def method_missing(*args)
      render_not_found
    end

    def set_locale
      # Si la locale est fournie sous forme de paramètre, c'est prioritaire
      if params[:locale]
        cookies[:locale] = params[:locale]

        if current_user # On l'ajoute même comme préférence
          current_user.preference.locale = params[:locale]
          current_user.preference.save if current_user.preference.changed?
        end
      end

      # En priorité la préférence de l'utilisateur
      if current_user and current_user.preference.locale
        I18n.locale = current_user.preference.locale
      else # Sinon on essaye de deviner
        http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
        http_accept_language ||= '' # Quand HTTP_ACCEPT_LANGUAGE n'est pas défini (console, ...)

        # Cookie ou dans HTTP_ACCEPT_LANGUAGE ou :fr par défaut
        I18n.locale = cookies[:locale] || http_accept_language.scan(/^[a-z]{2}/).first
      end

      I18n.locale = I18n.default_locale unless I18n.available_locales.include?(I18n.locale)
    end

    # Variable utiles dans le layout
    def set_layout_vars
      if current_user
        # On utilise les préférences utilisateurs pour les citations
        @random_quote = Quote.where(:tag => current_user.preference.quote_type).random
      end
      # Sinon on en prend une au hasard, et si il n'y en a pas, on en crée une vide
      @random_quote ||= Quote.random || Quote.new
    end

    # Méthodes publiques

    # Mobile ou pas mobile ?
    def mobile?
      # Si on a déjà définie si c'était un mobile ou pas, on utilise un pseudo-cache
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

    # Le layout dépend juste du type de support (mobile ou pas)
    def which_layout
      mobile? ? 'mobile' : 'application'
    end

    # Retourne l'utilisateur actuel (si il y en a un)
    def current_user
      @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end

    # Méthode pratique dans certaines classes pour trouver l'objet associé
    # à la relation polymorphe
    # Exemple : Pour trouve la news associée quand on poste un commentaire
    def find_polymorphicable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

    # Permet de transformer du Markdown en HTML
    def md(text)
      if text.nil?
        return nil
      else
        return RDiscount.new(text, :filter_html, :autolink, :no_pseudo_protocols).to_html.html_safe
      end
    end
end
