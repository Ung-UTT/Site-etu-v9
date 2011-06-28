class CommentsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_documentable

  def index
    @comments = @commentable.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  def show
    @comment = @commentable.comments.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user unless @commentable.class == Course # Commentaires anonymes sur les UVs

    if @comment.save
      flash[:notice] = 'Commentaire ajouté'
    end
    redirect_to @commentable
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to @commentable
  end

  private
    def find_documentable
      @commentable = find_polymorphicable
    end
end
