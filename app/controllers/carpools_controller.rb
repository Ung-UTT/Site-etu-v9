# encoding: utf-8
class CarpoolsController < ApplicationController
  load_and_authorize_resource

  def index
    @drivers = @carpools.select{|car| car.is_driver}
    @not_drivers = @carpools.select{|car| !car.is_driver}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @carpools }
    end
  end

  def show
    @comments = @carpool.comments
    @documents = @carpool.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @carpool }
    end
  end

  def new
    render 'layouts/_new', locals: {ressources: carpools_path}
  end

  def edit
    render 'layouts/_edit', locals: {ressource: @carpool}
  end

  def create
    @carpool.user = current_user

    if @carpool.save
      redirect_to(@carpool, notice: t('c.created'))
    else
      render action: "new"
    end
  end

  def update
    if @carpool.update_attributes(params[:carpool])
      redirect_to(@carpool, notice: t('c.updated'))
    else
      render action: "edit"
    end
  end

  def destroy
    @carpool.destroy

    redirect_to(carpools_url)
  end
end
