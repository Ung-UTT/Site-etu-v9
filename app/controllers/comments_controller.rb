# encoding: utf-8
class CommentsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_commentable

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
    # Commentaires anonymes sur les UVs
    @comment.user = current_user unless @commentable.class == Course
    if @comment.save
      flash[:notice] = t('c.comments.create')
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
