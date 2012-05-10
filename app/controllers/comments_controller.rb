# encoding: utf-8

# Les commentaires sont toujours associés à un contenu (@commentable)
class CommentsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_commentable

  def index
    @comments = @commentable.comments

    respond_to do |format|
      format.html do
        render '_list_and_add', locals:
          {commentable: @commentable, comments: @comments}
      end
      format.json { render json: @comments }
    end
  end

  def show
    @comment = @commentable.comments.find(params[:id])

    respond_to do |format|
      format.html do
        render '_list_and_add', locals:
          {commentable: @commentable, comments: [@comment]}
      end
      format.json { render json: @comment }
    end
  end

  def create
    @comment = @commentable.comments.build(params[:comment])
    # Commentaires anonymes sur les UVs
    @comment.user = current_user unless @commentable.class == Course
    if @comment.save
      flash[:notice] = t('c.created')
    end
    redirect_to @commentable
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to @commentable
  end

  private
  def find_commentable
    @commentable = find_polymorphicable
  end
end
