# encoding: utf-8
class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = News.visible.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def show
    @news = News.find(params[:id])
    @comments = @news.comments
    @documents = @news.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def new
    @news = News.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def create
    @news = News.new(params[:news])
    # Seul un modérateur peut s'auto-modérer une nouvelle news
    authorize! :moderate, @news if @news.is_moderated
    @news.user = current_user

    if @news.save
      redirect_to(@news, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @news = News.find(params[:id])
    # Seul un modérateur peut modifier le flag is_moderated
    authorize! :moderate, @news if params[:news][:is_moderated] != @news.is_moderated

    if @news.update_attributes(params[:news])
      redirect_to(@news, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @news = News.find(params[:id])
    @news.destroy

    redirect_to(news_index_url)
  end
end
