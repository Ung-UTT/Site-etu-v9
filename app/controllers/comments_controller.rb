class CommentsController < ApplicationController
  load_and_authorize_resource

  # TODO : Ajouter XML/JSON pour API
  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end

  def show
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
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

  private
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end
end
