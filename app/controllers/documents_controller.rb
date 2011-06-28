class DocumentsController < ApplicationController
  load_and_authorize_resource

  def index
    @documentable = find_documentable
    @documents = @documentable.documents

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  def show
    @documentable = find_documentable
    @document = @documentable.documents.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  def create
    @documentable = find_documentable
    @document = @documentable.documents.build(params[:document])

    if @document.save
      flash[:notice] = 'Document ajouté'
    end
    redirect_to @documentable
  end

  def destroy
    @documentable = find_documentable
    @document = @documentable.documents.find(params[:id])
    @document.destroy
    redirect_to @documentable
  end

  private
    # TODO: Helper pour find_commentable aussi
    def find_documentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
end
