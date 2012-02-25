# encoding: utf-8
class AnnalsController < ApplicationController
  load_and_authorize_resource

  # GET /annals
  # GET /annals.xml
  def index
    @annals = Annal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @annals }
    end
  end

  # GET /annals/1
  # GET /annals/1.xml
  def show
    @annal = Annal.find(params[:id])
    @comments = @annal.comments
    @documents = @annal.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annal }
    end
  end

  # GET /annals/new
  # GET /annals/new.xml
  def new
    @annal = Annal.new
    5.times { @annal.documents.build }

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @annal }
    end
  end

  # GET /annals/1/edit
  def edit
    @annal = Annal.find(params[:id])

    @annal.documents.build

    if @annal.documents.size < 5
      (5 - @annal.documents.size).times { @annal.documents.build }
    end
  end

  # POST /annals
  # POST /annals.xml
  def create
    @annal = Annal.new(params[:annal])

    respond_to do |format|
      if @annal.save
        format.html { redirect_to(@annal, :notice => t('c.annals.create')) }
        format.xml  { render :xml => @annal, :status => :created, :location => @annal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @annal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /annals/1
  # PUT /annals/1.xml
  def update
    @annal = Annal.find(params[:id])

    respond_to do |format|
      if @annal.update_attributes(params[:annal])
        format.html { redirect_to(@annal, :notice => t('c.annals.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @annal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /annals/1
  # DELETE /annals/1.xml
  def destroy
    @annal = Annal.find(params[:id])
    @annal.destroy

    respond_to do |format|
      format.html { redirect_to(annals_url) }
      format.xml  { head :ok }
    end
  end
end
