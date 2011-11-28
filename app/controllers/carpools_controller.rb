# encoding: utf-8
class CarpoolsController < ApplicationController
  load_and_authorize_resource

  # GET /carpools
  # GET /carpools.xml
  def index
    @carpools = Carpool.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carpools }
    end
  end

  # GET /carpools/1
  # GET /carpools/1.xml
  def show
    @carpool = Carpool.find(params[:id])
    @comments = @carpool.comments
    @documents = @carpool.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @carpool }
    end
  end

  # GET /carpools/new
  # GET /carpools/new.xml
  def new
    @carpool = Carpool.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @carpool }
    end
  end

  # GET /carpools/1/edit
  def edit
    @carpool = Carpool.find(params[:id])
  end

  # POST /carpools
  # POST /carpools.xml
  def create
    @carpool = Carpool.new(params[:carpool])
    @carpool.user = current_user

    respond_to do |format|
      if @carpool.save
        format.html { redirect_to(@carpool, :notice => t('c.carpool.create')) }
        format.xml  { render :xml => @carpool, :status => :created, :location => @carpool }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @carpool.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /carpools/1
  # PUT /carpools/1.xml
  def update
    @carpool = Carpool.find(params[:id])

    respond_to do |format|
      if @carpool.update_attributes(params[:carpool])
        format.html { redirect_to(@carpool, :notice => t('c.carpool.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @carpool.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /carpools/1
  # DELETE /carpools/1.xml
  def destroy
    @carpool = Carpool.find(params[:id])
    @carpool.destroy

    respond_to do |format|
      format.html { redirect_to(carpools_url) }
      format.xml  { head :ok }
    end
  end
end
