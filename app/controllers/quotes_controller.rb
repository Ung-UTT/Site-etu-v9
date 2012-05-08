# encoding: utf-8
class QuotesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotes }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quote }
    end
  end

  def new
    render_new quotes_path
  end

  def edit
    render_edit @quote
  end

  def create
    if @quote.save
      redirect_to(@quote, notice: t('c.created'))
    else
      render_edit @quote
    end
  end

  def update
    if @quote.update_attributes(params[:quote])
      redirect_to(@quote, notice: t('c.updated'))
    else
      render_edit @quote
    end
  end

  def destroy
    @quote.destroy

    redirect_to(quotes_url)
  end
end
