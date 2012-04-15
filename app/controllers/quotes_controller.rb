# encoding: utf-8
class QuotesController < ApplicationController
  load_and_authorize_resource

  def index
    @quotes = Quote.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @quotes }
    end
  end

  def show
    @quote = Quote.find(params[:id])
    @comments = @quote.comments

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @quote }
    end
  end

  def new
    @quote = Quote.new
  end

  def edit
    @quote = Quote.find(params[:id])
  end

  def create
    @quote = Quote.new(params[:quote])

    if @quote.save
      redirect_to(@quote, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @quote = Quote.find(params[:id])

    if @quote.update_attributes(params[:quote])
      redirect_to(@quote, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy

    redirect_to(quotes_url)
  end
end
