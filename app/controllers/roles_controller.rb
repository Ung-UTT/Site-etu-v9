# encoding: utf-8
class RolesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  def join
    if @role.users.include?(@user)
      redirect_to @role, :notice => t('c.roles.already_join')
    else
      @role.users << @user
      redirect_to @role, :notice => t('c.roles.join')
    end
  end

  def disjoin
    @role.users.delete(@user)

    redirect_to @role, :notice => t('c.roles.disjoin')
  end

  def edit
  end

  def update
    if @role.update_attributes(params[:role])
      redirect_to(@role, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @role.destroy

    redirect_to(roles_url)
  end
end
