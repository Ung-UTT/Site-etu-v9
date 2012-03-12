# encoding: utf-8
class CasController < ApplicationController
  skip_authorization_check
  before_filter RubyCAS::Filter, :only => :new

  # Essayer de créer une connexion au CAS
  def new
    unless session[:cas_user]
      redirect_to :root, :notice => "Fail :("
    else
      if current_user
        add_cas(current_user)
        redirect_to :root, :notice => "#{session[:cas_user]}, ton compte UTT a été ajouté !"

      elsif @user = User.find_by_login(session[:cas_user])
        add_cas(@user)
        cookies[:auth_token] = @user.auth_token
        redirect_to :root, :notice => "#{session[:cas_user]}, te revoilà !"

      else
        password = SecureRandom.base64 # Génére un mot de passe que personne ne connaîtra
        @user = User.create(:login => session[:cas_user], :password => password,
                            :password_confirmation => password, :cas => true,
                            :email => session[:cas_user] + '@utt.fr')
        cookies[:auth_token] = @user.auth_token
        redirect_to :root, :notice => "#{session[:cas_user]}, te voilà connecté avec ton compte UTT."
      end
    end
  end

  private
    def add_cas(user)
      unless user.cas == true
        user.cas = true
        user.save
      end
    end
end
