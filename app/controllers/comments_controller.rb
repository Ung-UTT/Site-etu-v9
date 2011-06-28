class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @commentable = find_polymorphicable
    @comments = @commentable.comments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  def show
    @commentable = find_polymorphicable
    @comment = @commentable.comments.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user unless @commentable.class == Course # Commentaires anonymes sur les UVs

    if @comment.save
      flash[:notice] = 'Commentaire ajouté'
    end
    redirect_to @commentable
  end

  def destroy
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to @commentable
  end
end
