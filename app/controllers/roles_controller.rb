# encoding: utf-8
class RolesController < ApplicationController
  load_and_authorize_resource

  def index
    @roles = Role.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  def join
    @role = Role.find(params[:id])
    @user = User.find(params[:users])

    if @role.users.include?(@user)
      redirect_to @role, :notice => t('c.roles.already_join')
    else
      @role.users << @user
      redirect_to @role, :notice => t('c.roles.join')
    end
  end

  def disjoin
    @role = Role.find(params[:id])

    # Ne peut que supprimer sa partition aux rôles (sauf si il a du pouvoir)
    if params[:user_id].to_i != current_user.id
      authorize! :destroy, @role
    end

    @user = User.find(params[:user_id])
    @role.users.delete(@user)

    redirect_to @role, :notice => t('c.roles.disjoin')
  end

  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      redirect_to(@role, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      redirect_to(@role, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    redirect_to(roles_url)
  end
end
