# encoding: utf-8
class CoursesController < ApplicationController
  load_and_authorize_resource

  before_filter :search, only: :index

  def index
    respond_to do |format|
      format.html
      format.json { render json: @courses }
    end
  end

  def show
    @comments = @course.comments
    @documents = @course.documents

    respond_to do |format|
      format.html
      format.json { render json: @course }
    end
  end

  def new
    render_new courses_path
  end

  def edit
    render_edit @course
  end

  def create
    if @course.save
      redirect_to(@course, notice: t('c.created'))
    else
      render_edit @course
    end
  end

  def update
    if @course.update_attributes(params[:course])
      redirect_to(@course, notice: t('c.updated'))
    else
      render_edit @course
    end
  end

  def destroy
    @course.destroy

    redirect_to(courses_url)
  end
end
