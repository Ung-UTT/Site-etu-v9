# encoding: utf-8
class ClassifiedsController < ApplicationController
  load_and_authorize_resource

  def index
    @classifieds = Classified.order('created_at desc').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classifieds }
    end
  end

  def show
    @classified = Classified.find(params[:id])
    @comments = @classified.comments
    @documents = @classified.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classified }
    end
  end

  def new
    @classified = Classified.new
  end

  def edit
    @classified = Classified.find(params[:id])
  end

  def create
    @classified = Classified.new(params[:classified])
    @classified.user = current_user

    if @classified.save
      redirect_to(@classified, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @classified = Classified.find(params[:id])

    if @classified.update_attributes(params[:classified])
      redirect_to(@classified, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @classified = Classified.find(params[:id])
    @classified.destroy

    redirect_to(classifieds_url)
  end
end
