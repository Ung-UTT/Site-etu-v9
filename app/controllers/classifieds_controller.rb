# encoding: utf-8
class ClassifiedsController < ApplicationController
  load_and_authorize_resource

  def index
    @classifieds = search_and_paginate(@classifieds)
    redirect_to(@classifieds.first) and return if @classifieds.one? and params[:q]

    respond_to do |format|
      format.html
      format.json { render json: @classifieds }
      format.rss { render layout: false }
    end
  end

  def show
    @comments = @classified.comments
    @documents = @classified.documents

    respond_to do |format|
      format.html
      format.json { render json: @classified }
    end
  end

  def new
    render_new classifieds_path
  end

  def edit
    render_edit @classified
  end

  def create
    @classified.user = current_user

    if @classified.save
      redirect_to(@classified, notice: t('c.created'))
    else
      render_edit @classified
    end
  end

  def update
    if @classified.update_attributes(params[:classified])
      redirect_to(@classified, notice: t('c.updated'))
    else
      render_edit @classified
    end
  end

  def destroy
    @classified.destroy

    redirect_to(classifieds_url)
  end
end
