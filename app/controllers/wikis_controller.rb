class WikisController < ApplicationController
  load_and_authorize_resource

  # Redirige vers la page d'accueil
  def index
    @wiki = Wiki.homepage

    redirect_to @wiki, only_path: true
  end

  def show
    @documents = @wiki.documents
    @comments = @wiki.comments

    respond_to do |format|
      format.html
      format.json { render json: @wiki }
    end
  end

  def new
    render_new wikis_path
  end

  def edit
    render_edit @wiki
  end

  def create
    if @wiki.save
      redirect_to @wiki, notice: t('c.created')
    else
      render_edit @wiki
    end
  end

  def update
    if @wiki.update_attributes(params[:wiki])
      redirect_to @wiki, notice: t('c.updated')
    else
      render_edit @wiki
    end
  end

  def destroy
    @wiki.destroy

    redirect_to wikis_url
  end
end
