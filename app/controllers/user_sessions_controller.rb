class UserSessionsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    user = User.authenficate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      flash[:notice] = t('c.user_sessions.create')
      redirect_to :root
    else
      flash[:notice] = t('c.user_sessions.failed')
      render :action => :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cas_user] = nil
    redirect_to :back, :notice => t('c.user_sessions.destroy')
  end
end
