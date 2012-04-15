# encoding: utf-8
class CoursesController < ApplicationController
  load_and_authorize_resource

  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @courses }
    end
  end

  def show
    @course = Course.find(params[:id])
    @comments = @course.comments
    @documents = @course.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(params[:course])

    if @course.save
      redirect_to(@course, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @course = Course.find(params[:id])

    if @course.update_attributes(params[:course])
      redirect_to(@course, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    redirect_to(courses_url)
  end
end
