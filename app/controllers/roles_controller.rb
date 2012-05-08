# encoding: utf-8
class RolesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end

  def show
    set_first_users

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @role }
    end
  end

  def edit
    render_edit @role
  end

  def update
    if @role.update_attributes(params[:role])
      redirect_to(@role, notice: t('c.updated'))
    else
      render_edit @role
    end
  end

  def destroy
    @role.destroy

    redirect_to(roles_url)
  end
end
