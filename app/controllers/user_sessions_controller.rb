# encoding: utf-8
class UserSessionsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      flash[:notice] = t('c.user_sessions.create')
      redirect_to :root
    else
      flash[:alert] = t('c.user_sessions.failed')
      render :action => :new
    end
  end

  def destroy
    cas = current_user.cas
    cookies.delete(:auth_token)
    session[:cas_user] = nil
    flash[:notice] = t('c.user_sessions.destroy')
    if cas
      redirect_to Rails.application.config.rubycas.cas_base_url + '/logout?service=' + CGI::escape(root_path(:only_path => false))
    else
      redirect_to :root
    end
  end
end
