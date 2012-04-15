# encoding: utf-8
class CarpoolsController < ApplicationController
  load_and_authorize_resource

  def index
    @carpools = Carpool.all
    @drivers = @carpools.select{|car| car.is_driver}
    @not_drivers = @carpools.select{|car| !car.is_driver}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carpools }
    end
  end

  def show
    @carpool = Carpool.find(params[:id])
    @comments = @carpool.comments
    @documents = @carpool.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @carpool }
    end
  end

  def new
    @carpool = Carpool.new
  end

  def edit
    @carpool = Carpool.find(params[:id])
  end

  def create
    @carpool = Carpool.new(params[:carpool])
    @carpool.user = current_user

    if @carpool.save
      redirect_to(@carpool, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @carpool = Carpool.find(params[:id])

    if @carpool.update_attributes(params[:carpool])
      redirect_to(@carpool, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @carpool = Carpool.find(params[:id])
    @carpool.destroy

    redirect_to(carpools_url)
  end
end
