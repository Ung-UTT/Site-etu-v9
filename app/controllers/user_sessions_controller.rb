class UserSessionsController < ApplicationController
  load_and_authorize_resource

  def new
    # @user_session est définit dans ApplicationController pour toutes les pages
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('c.user_sessions.create')
      redirect_to :root
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t('c.user_sessions.destroy')
    session[:cas_user] = nil
    redirect_to :back
  end
end
