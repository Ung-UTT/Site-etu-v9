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

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def password_reset
    if params[:email]
      user = User.find_by_email(params[:email])
      if user.nil?
        flash[:alert] = t('c.users.bad_email')
      else
        user.perishable_token = SecureRandom.hex
        user.perishable_token_date = Time.now + 1.week
        UserMailer.password_reset(user)
        flash[:notice] = t('c.users.email_sent')
      end
    elsif params[:token]
      user = User.find_by_perishable_token(params[:token])
      if user.nil? and user.perishable_token_date > Time.now
        flash[:alert] =  t('c.users.bad_token')
      else
        user.password = SecureRandom.hex(2)
        user.password_confirmation = user.password
        user.perishable_token = nil
        user.perishable_token_date = nil
        user.save
        redirect_to :root, :notice => t('c.users.new_password', :password => user.password)
      end
    end
  end

  def new
  end

  def edit
  end

  def create
    if @user.save
      cookies[:auth_token] = @user.auth_token
      redirect_to(:root, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to(@user, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @user.destroy

    redirect_to(users_url)
  end
end
