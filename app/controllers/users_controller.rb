# encoding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:q].nil?
      @users = @users.page(params[:page])
    else
      # Recherche simple dans le trombi
      @users = @users.search(params[:q])
      @users = Kaminari::paginate_array(@users).page(params[:page]).per(100)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def edit
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to(root_path, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end
end
