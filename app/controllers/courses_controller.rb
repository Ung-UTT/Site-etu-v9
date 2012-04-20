# encoding: utf-8
class CoursesController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end

  def show
    @comments = @course.comments
    @documents = @course.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  def new
  end

  def edit
  end

  def create
    if @course.save
      redirect_to(@course, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    if @course.update_attributes(params[:course])
      redirect_to(@course, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @course.destroy

    redirect_to(courses_url)
  end
end
