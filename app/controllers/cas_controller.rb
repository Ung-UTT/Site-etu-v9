# encoding: utf-8
class CasController < ApplicationController
  skip_authorization_check
  # La librairie RubyCAS gère les redirections, etc...
  before_filter RubyCAS::Filter, only: :new

  # Essayer de créer une connexion au CAS
  def new
    if session[:cas_user].blank?
      # La connexion a échouée pour une raison indéterminée
      redirect_to :root, alert: "Fail :("
      return
    end

    # On a le pseudo de l'utilisateur
    if current_user # Si il est déjà connecté
      redirect_to :root, notice: t('c.cas.already_connected')
    # Si il existe déjà dans la base de données
    elsif @user = User.find_by_login(session[:cas_user])
      sign_in(@user)
      redirect_to :root, notice: t('c.cas.already_exist')
    else # Sinon on crée un compte
      @user = User.simple_create(session[:cas_user])
      sign_in(@user)
      redirect_to :root, notice: t('c.cas.user_created')
    end
  end

  def destroy
    sign_out(@user)
    redirect_to [
      Rails.application.config.rubycas.cas_base_url,
      '/logout?service=',
      CGI::escape(root_path(only_path: false))
    ].join, notice: t('c.user_sessions.destroyed')
  end
end
