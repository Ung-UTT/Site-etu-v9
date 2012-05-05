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
      format.html
      format.json  { render json: @users }
    end
  end

  def edit
  end

  def show
    respond_to do |format|
      format.html
      format.json  { render json: @user }
    end
  end

  def update
    params.delete(:login) # cannot update his login

    if @user.update_without_password(params[:user])
      redirect_to(@user, notice: t('c.updated'))
    else
      render action: "edit"
    end
  end
end
