class WikisController < ApplicationController
  load_and_authorize_resource

  # Redirige vers la page d'accueil
  def index
    @wiki = Wiki.homepage

    redirect_to @wiki
  end

  def show
    @documents = @wiki.documents

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @wiki }
    end
  end

  def new
    redirect_to @wiki, :notice => 'Wiki was successfully created.'
  end

  def edit
  end

  def create
    if @wiki.save
      redirect_to @wiki, :notice => t('c.created')
    else
      render :action => "new"
    end
  end

  def update
    if @wiki.update_attributes(params[:wiki])
      redirect_to @wiki, :notice => t('c.updated')
    else
      render :action => "edit"
    end
  end

  def destroy
    @wiki.destroy

    redirect_to wikis_url
  end
end
