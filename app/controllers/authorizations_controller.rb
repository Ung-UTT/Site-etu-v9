class AuthorizationsController < ApplicationController
  load_and_authorize_resource

  def create
    # On récupère les infos de l'authentification
    omniauth = request.env['rack.auth']
    @auth = Authorization.find_from_hash(omniauth)

    if current_user
      flash[:notice] = "L'authentication via #{omniauth['provider']} à été ajoutée"
      current_user.authorizations.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
    elsif @auth
      flash[:notice] = "Bienvenue à toi, de nouveau depuis #{omniauth['provider']}"
      UserSession.create(@auth.user, true)      # On connecte l'utilisateur
    else
      password = ActiveSupport::SecureRandom.hex(2) # Exemples : 0ecc 4691 f742 5c03 66c3
      @new_auth = Authorization.create_from_hash(omniauth, password, current_user)
      flash[:notice] = "Bienvenue utilisateur de #{omniauth['provider']}. Un compte a été créé pour toi !"
      flash[:notice] += " Pour te connecter avec tes identifiant/mot de passe, ton mot de passe est #{password}."
      UserSession.create(@new_auth.user, true) # On connecte l'utilisateur
    end
    redirect_to :root
  end

  def failure
    flash[:notice] = "Mince, l'authentification a échoué"
    redirect_to :root
  end

  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "La connexion avec #{@authorization.provider} a été supprimée."
    @authorization.destroy
    redirect_to :root
  end
end
