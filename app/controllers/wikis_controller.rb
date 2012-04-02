class WikisController < ApplicationController
  load_and_authorize_resource

  # Redirige vers la page d'accueil
  def index
    @wiki = Wiki.homepage

    redirect_to @wiki
  end

  # GET /wikis/1
  # GET /wikis/1.json
  def show
    @wiki = Wiki.find(params[:id])
    @documents = @wiki.documents

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @wiki }
    end
  end

  # GET /wikis/new
  # GET /wikis/new.json
  def new
    @wiki = Wiki.new

    respond_to do |format|
      format.html { redirect_to @wiki, :notice => 'Wiki was successfully created.' }
      format.json { render :json => @wiki, :status => :created, :location => @wiki }
    end
  end

  # GET /wikis/1/edit
  def edit
    @wiki = Wiki.find(params[:id])
  end

  # POST /wikis
  # POST /wikis.json
  def create
    @wiki = Wiki.new(params[:wiki])

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to @wiki, :notice => t('c.create') }
        format.json { render :json => @wiki, :status => :created, :location => @wiki }
      else
        format.html { render :action => "new" }
        format.json { render :json => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wikis/1
  # PUT /wikis/1.json
  def update
    @wiki = Wiki.find(params[:id])

    respond_to do |format|
      if @wiki.update_attributes(params[:wiki])
        format.html { redirect_to @wiki, :notice => t('c.update') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @wiki.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.json
  def destroy
    @wiki = Wiki.find(params[:id])
    @wiki.destroy

    respond_to do |format|
      format.html { redirect_to wikis_url }
      format.json { head :no_content }
    end
  end
end
