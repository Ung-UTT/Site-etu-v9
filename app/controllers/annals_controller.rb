# encoding: utf-8
class AnnalsController < ApplicationController
  load_and_authorize_resource

  before_filter :build_documents, only: [:new, :edit]

  def index
    respond_to do |format|
      format.html
      format.xml  { render :xml => @annals }
    end
  end

  def show
    @documents = @annal.documents

    respond_to do |format|
      format.html
      format.xml  { render :xml => @annal }
    end
  end

  def new
  end

  def edit
  end

  def create
    if @annal.save
      redirect_to(@annal, :notice => t('c.created'))
    else
      build_documents
      render :action => "new"
    end
  end

  def update
    if @annal.update_attributes(params[:annal])
      redirect_to(@annal, :notice => t('c.updated'))
    else
      build_documents
      render :action => "edit"
    end
  end

  def destroy
    @annal.destroy

    redirect_to(annals_url)
  end

  private
  def build_documents
    @annal.documents.build
  end
end
