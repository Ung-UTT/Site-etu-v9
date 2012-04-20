# encoding: utf-8
class NewsController < ApplicationController
  load_and_authorize_resource

  def index
    @news = @news.visible.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def show
    @comments = @news.comments
    @documents = @news.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news }
    end
  end

  def edit
  end

  def create
    @news.user = current_user

    if @news.save
      redirect_to(news_index_url, :notice => t('c.created_but_not_moderated'))
    else
      render :action => "new"
    end
  end

  def update
    if @news.update_attributes(params[:news])
      redirect_to(@news, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @news.destroy

    redirect_to(news_index_url)
  end
end
