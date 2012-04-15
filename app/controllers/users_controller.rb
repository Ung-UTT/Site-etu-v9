# encoding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource

  # GET /users
  # GET /users.xml
  def index
    if params[:q].nil?
      @users = User.page(params[:page])
    else
      # Recherche simple dans le trombi
      @users = User.search(params[:q])
      @users = Kaminari::paginate_array(@users).page(params[:page]).per(100)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

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

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        cookies[:auth_token] = @user.auth_token
        format.html { redirect_to(:root, :notice => t('c.create')) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => t('c.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
