# encoding: utf-8
class QuotesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotes }
    end
  end

  def show
    @comments = @quote.comments

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  def new
    render 'layouts/_new', locals: {ressources: quotes_path}
  end

  def edit
    render 'layouts/_edit', locals: {ressource: @quote}
  end

  def create
    if @quote.save
      redirect_to(@quote, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    if @quote.update_attributes(params[:quote])
      redirect_to(@quote, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @quote.destroy

    redirect_to(quotes_url)
  end
end
