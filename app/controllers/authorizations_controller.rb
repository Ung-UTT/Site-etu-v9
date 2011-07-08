class AuthorizationsController < ApplicationController
  load_and_authorize_resource

  def create
    # On récupère les infos de l'authentification
    omniauth = request.env['rack.auth']

    unless omniauth
      return failure
    end

    @auth = Authorization.find_from_hash(omniauth)

    if current_user
      flash[:notice] = t('c.authorizations.add', :provider => omniauth['provider'])
      current_user.authorizations.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
    elsif @auth
      flash[:notice] = t('c.authorizations.welcome', :provider => omniauth['provider'])
      UserSession.create(@auth.user, true)     # On connecte l'utilisateur
    else
      password = ActiveSupport::SecureRandom.hex(2) # Exemples : 0ecc 4691 f742 5c03 66c3
      @new_auth = Authorization.create_from_hash(omniauth, password, current_user)
      flash[:notice] = t('c.authorizations.new',
                       {:provider => omniauth['provider'], :password =>password})
      UserSession.create(@new_auth.user, true) # On connecte l'utilisateur
    end
    redirect_to :root
  end

  def failure
    redirect_to :root, :alert => t('c.authorizations.error', :provider => omniauth['provider'])
  end

  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    @authorization.destroy
    redirect_to :root, :notice => t('c.authorizations.delete', :provider => omniauth['provider'])
  end
end
