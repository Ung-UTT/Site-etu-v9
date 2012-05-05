# encoding: utf-8
class ClassifiedsController < ApplicationController
  load_and_authorize_resource

  def index
    @classifieds = @classifieds.order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classifieds }
    end
  end

  def show
    @comments = @classified.comments
    @documents = @classified.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classified }
    end
  end

  def new
    render 'layouts/_new', locals: {ressources: classifieds_path}
  end

  def edit
    render 'layouts/_edit', locals: {ressource: @classified}
  end

  def create
    @classified.user = current_user

    if @classified.save
      redirect_to(@classified, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    if @classified.update_attributes(params[:classified])
      redirect_to(@classified, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @classified.destroy

    redirect_to(classifieds_url)
  end
end
