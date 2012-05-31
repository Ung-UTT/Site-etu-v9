# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  # Permet de récupérer les erreurs et de les traiter
  around_filter :catch_exceptions
  # Permet de définir des variables utiles à toutes les vues
  before_filter :set_layout_vars, :set_locale
  # Méthode que l'on peut utiliser dans les controlleurs et dans les vues
  helper_method :'mobile?', :md

  # Gére les erreurs 404
  def render_not_found
    logger.error '[404] ' + request.fullpath
    render template: "shared/404", status: 404
  end

  def deploy
    # Only Github and us are allowed to trigger the deploy script
    return unless request.env['REMOTE_ADDR'].in?(%w[
      207.97.227.253
      50.57.128.197
      108.171.174.178
      127.0.0.1
    ])

    return unless payload = params[:payload]
    push = JSON.parse payload

    if push["ref"] == "refs/heads/master"
      system "#{Rails.root}/script/deploy 2>&1 >> #{Rails.root}/log/deploy.log &"
    end

    render text: 'OK'
  end

  # Gére la prévisualisation du Markdown
  def preview
    render text: md(params[:data])
  end

  private
  # Gére les accès refusés
  def render_access_denied(exception)
    message = t('c.application.denied')

    logger.error '[401] ' + request.fullpath + ' | ' + message

    if current_user
      redirect_to root_url, alert: message
    else
      # Redirect to the CAS connexion page
      redirect_to new_cas_path, alert: message
    end
  end

  # Gére les erreurs de code (variable non définie, ... etc)
  def render_error(exception)
    logger.error '[500] ' + request.fullpath + ' | ' + exception.inspect

    render template: "shared/500", status: 500,
           locals: {exception: exception}
  end

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
      UserMailer.error(exception, request).deliver
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
      @random_quote = Quote.where(tag: current_user.preference.quote_type).random
    end
    # Sinon on en prend une au hasard, et si il n'y en a pas, on en crée une vide
    @random_quote ||= Quote.random
    # oh la belle citation par défaut :P
    @random_quote ||= Quote.new(content: 'Qui boit la gnôle casse la bagnôle !')
  end

  # Mobile ou pas mobile ?
  def mobile?
    # Si l'utilisateur demande une version particulière, elle prévaut
    if params[:mobile]
      if params[:mobile] == 'true'
        cookies[:force_mobile] = 'true'
      else
        cookies[:force_mobile] = 'false'
      end
    end

    return cookies[:force_mobile] if cookies[:force_mobile]

    # Sinon, on regarde si c'est un téléphone
    detect_mobile?
  end

  # Méthode pratique dans certaines classes pour trouver l'objet associé
  # à la relation polymorphe
  # Exemple : Pour trouve la news associée quand on poste un commentaire
  def find_polymorphicable
    params.each do |name, value|
      return $1.classify.constantize.find(value) if name =~ /(.+)_id$/
    end
    nil
  end

  # Permet de transformer du Markdown en HTML
  def md(text)
    RDiscount.new(text,
      :filter_html, :autolink, :no_pseudo_protocols
    ).to_html.html_safe unless text.nil?
  end

  # Définit les utilisateurs mis par défaut dans les formulaires
  def set_first_users
    @first_users = User.first(20)
  end

  # Shortcut to use the "new" layout
  def render_new(resources)
    render 'layouts/_new', locals: {resources: resources}
  end

  # Shortcut to use the "edit" layout
  def render_edit(resource)
    render 'layouts/_edit', locals: {resource: resource}
  end

  # Shortcut to add search and pagination to a controller
  def search_and_paginate
    resources = instance_variable_get("@#{params[:controller]}")
    return if resources.blank?

    if params[:q].nil?
      resources = resources.page(params[:page])
    else
      klass = resources.first.class

      # Simple search via Searchable
      resources = klass.search(params[:q])
      if resources.one? and (params[:format].in?(nil, 'html'))
        redirect_to resources.first
      end

      # Pagination with Kaminari
      resources = Kaminari::paginate_array(resources).page(params[:page])
      resources = resources.per(klass.default_per_page)
    end

    instance_variable_set("@#{params[:controller]}", resources)
  end

  # Détecte si l'utilisateur utilise son portable
  def detect_mobile?
    return false if request.user_agent.nil? || request.user_agent.length < 4
    /android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent)
  end
end
