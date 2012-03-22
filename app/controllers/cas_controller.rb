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
        current_user.become_a_student
        redirect_to :root, :notice => "#{session[:cas_user]}, ton compte UTT a été ajouté !"
      # Si il existe déjà dans la base de données
      elsif @user = User.find_by_login(session[:cas_user])
        @user.become_a_student
        cookies[:auth_token] = @user.auth_token
        redirect_to :root, :notice => "#{session[:cas_user]}, te revoilà !"
      else # Sinon on crée un compte
        password = SecureRandom.base64 # Génére un mot de passe que personne ne connaîtra
        @user = User.new(:login => session[:cas_user], :password => password,
                            :password_confirmation => password)
        if @user.ldap_attributes.empty?
          # Pas accès au LDAP
          @user.email =  @user.login + '@utt.fr'
        else
          # Accès au LDAP
          @user.email = @user.ldap_attributes['mail']
        end
        @user.become_a_student

        @user.save

        cookies[:auth_token] = @user.auth_token
        redirect_to :root, :notice => "#{session[:cas_user]}, te voilà connecté avec ton compte UTT."
      end
    end
  end
end
