# encoding: utf-8
class DocumentsController < ApplicationController
  before_filter :find_documentable
  load_and_authorize_resource

  def index
    @documents = @documentable.documents

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  def show
    @document = @documentable.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  def create
    @document = @documentable.documents.build(params[:document])

    if @document.save
      flash[:notice] = t('c.created')
    end
    redirect_to @documentable
  end

  def destroy
    @document = @documentable.documents.find(params[:id])
    @document.destroy
    redirect_to @documentable
  end

  private
  def find_documentable
    @documentable = find_polymorphicable
  end
end
