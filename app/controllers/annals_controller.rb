# encoding: utf-8
class AnnalsController < ApplicationController
  load_and_authorize_resource

  before_filter :build_documents, only: [:new, :edit]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @annals }
    end
  end

  def show
    @documents = @annal.documents
    @comments = @annal.comments

    respond_to do |format|
      format.html
      format.json { render json: @annal }
    end
  end

  def new
    render_new annals_path
  end

  def edit
    render_edit @annal
  end

  def create
    if @annal.save
      redirect_to(@annal, notice: t('c.created'))
    else
      build_documents
      render_edit @annal
    end
  end

  def update
    if @annal.update_attributes(params[:annal])
      redirect_to(@annal, notice: t('c.updated'))
    else
      build_documents
      render_edit @annal
    end
  end

  def destroy
    @annal.destroy

    redirect_to(annals_url)
  end

  private
  def build_documents
    3.times { @annal.documents.build }
  end
end
