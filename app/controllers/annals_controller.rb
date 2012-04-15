# encoding: utf-8
class AnnalsController < ApplicationController
  load_and_authorize_resource

  def index
    @annals = Annal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @annals }
    end
  end

  def show
    @annal = Annal.find(params[:id])
    @comments = @annal.comments
    @documents = @annal.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @annal }
    end
  end

  def new
    @annal = Annal.new
    # Permet d'avoir des formulaires pour 5 documents
    5.times { @annal.documents.build }
  end

  def edit
    @annal = Annal.find(params[:id])

    # Permet d'avoir au minimum un formulaire
    @annal.documents.build
    if @annal.documents.size < 5 # On ajoute des formulaires pour au moins 5 documents
      (5 - @annal.documents.size).times { @annal.documents.build }
    end
  end

  def create
    @annal = Annal.new(params[:annal])

    if @annal.save
      redirect_to(@annal, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @annal = Annal.find(params[:id])

    if @annal.update_attributes(params[:annal])
      redirect_to(@annal, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @annal = Annal.find(params[:id])
    @annal.destroy

    redirect_to(annals_url)
  end
end
