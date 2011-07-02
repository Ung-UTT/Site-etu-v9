class DocumentsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_documentable

  def index
    @documents = @documentable.documents

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  def show
    @document = @documentable.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  def create
    @document = @documentable.documents.build(params[:document])

    if @document.save
      flash[:notice] = 'Document ajouté'
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
