# encoding: utf-8
class AnnalsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @annals }
    end
  end

  def show
    @documents = @annal.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annal }
    end
  end

  def new
  end

  def edit
    # Permet d'avoir au minimum un formulaire
    @annal.documents.build
  end

  def create
    if @annal.save
      redirect_to(@annal, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    if @annal.update_attributes(params[:annal])
      redirect_to(@annal, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @annal.destroy

    redirect_to(annals_url)
  end
end
