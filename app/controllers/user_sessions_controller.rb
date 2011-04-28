class UserSessionsController < ApplicationController
  load_and_authorize_resource

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    # @user_session is defined in application controller for all views
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = 'Salut, vous êtes maintenant connecté.'
      redirect_to :root
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Au revoir, vous êtes dorénavant déconnecté.'
    redirect_to :root
  end
end
