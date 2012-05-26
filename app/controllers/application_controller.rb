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
    return unless %w(
      207.97.227.253
      50.57.128.197
      108.171.174.178
      127.0.0.1
    ).include? request.env['REMOTE_ADDR']

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
      # Redirige vers la page de login si l'utilisateur n'est pas déjà loggé
      redirect_to new_user_session_url, alert: message
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
    @is_mobile = (detect_mobile? and cookies[:force_mobile] != 'false') or
                 (cookies[:force_mobile] == 'true')

    @is_mobile
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
  def search_and_paginate(resources)
    return [] if resources.nil? or resources.empty?

    klass = resources.first.class

    if params[:q].nil?
      resources = resources.page(params[:page])
    else
      # Simple search via Searchable
      resources = klass.search(params[:q])
      # Pagination with Kaminari
      resources = Kaminari::paginate_array(resources).page(params[:page])
      resources = resources.per(klass.default_per_page)
    end

    resources
  end

  # Détecte si l'utilisateur utilise son portable
  def detect_mobile?
    return false if request.user_agent.nil? || request.user_agent.length < 4
    /android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3])
  end
end
