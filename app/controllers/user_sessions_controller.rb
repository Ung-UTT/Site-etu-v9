# encoding: utf-8
class UserSessionsController < ApplicationController
  skip_authorization_check

  # Page de connexion
  def new
  end

  # Connexion
  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      flash[:notice] = t('c.user_sessions.created')
      redirect_to :root
    else
      flash[:alert] = t('c.user_sessions.failed')
      render :action => :new
    end
  end

  # Déconnexion
  def destroy
    redirect_to_cas = current_user && current_user.utt?

    cookies.delete(:auth_token) # Supprime le cookie de connexion
    session[:cas_user] = nil # Supprime le cookie du CAS
    flash[:notice] = t('c.user_sessions.destroyed')

    if redirect_to_cas
      # Déconnexion globale du CAS (Single Sign Out)
      redirect_to Rails.application.config.rubycas.cas_base_url + '/logout?service=' + CGI::escape(root_path(:only_path => false))
    else
      redirect_to :root
    end
  end
end
