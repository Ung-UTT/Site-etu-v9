# encoding: utf-8
class CasController < ApplicationController
  skip_authorization_check
  # La librairie RubyCAS gère les redirections, etc...
  before_filter RubyCAS::Filter, :only => :new

  # Essayer de créer une connexion au CAS
  def new
    unless session[:cas_user]
      # La connexion a échouée pour une raison indéterminée
      redirect_to :root, :notice => "Fail :("
    else
      # On a le pseudo de l'utilisateur
      if current_user # Si il est déjà connecté
        redirect_to :root, :notice => "#{session[:cas_user]}, tu étais déjà connecté..."
      # Si il existe déjà dans la base de données
      elsif @user = User.find_by_login(session[:cas_user])
        cookies[:auth_token] = @user.auth_token
        redirect_to :root, :notice => "#{session[:cas_user]}, te revoilà !"
      else # Sinon on crée un compte
        @user = User.simple_create(session[:cas_user])

        cookies[:auth_token] = @user.auth_token
        redirect_to :root, :notice => "#{session[:cas_user]}, te voilà connecté avec ton compte UTT."
      end
    end
  end
end
