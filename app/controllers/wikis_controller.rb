class WikisController < ApplicationController
  load_and_authorize_resource

  # Redirige vers la page d'accueil
  def index
    @wiki = Wiki.homepage

    redirect_to @wiki
  end

  def show
    @wiki = Wiki.find(params[:id])
    @documents = @wiki.documents

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @wiki }
    end
  end

  def new
    @wiki = Wiki.new

    redirect_to @wiki, :notice => 'Wiki was successfully created.'
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def create
    @wiki = Wiki.new(params[:wiki])

    if @wiki.save
      redirect_to @wiki, :notice => t('c.create')
    else
      render :action => "new"
    end
  end

  def update
    @wiki = Wiki.find(params[:id])

    if @wiki.update_attributes(params[:wiki])
      redirect_to @wiki, :notice => t('c.update')
    else
      render :action => "edit"
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    @wiki.destroy

    redirect_to wikis_url
  end
end
