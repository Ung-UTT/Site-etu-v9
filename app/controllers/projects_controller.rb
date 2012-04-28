# encoding: utf-8
class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  def show
    @comments = @project.comments
    @documents = @project.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  def join
    if @project.users.include?(current_user)
      redirect_to @project, :notice => t('c.projects.already_joined')
    else
      @project.users << current_user
      @project.save
      redirect_to @project, :notice => t('c.projects.joined')
    end
  end

  def disjoin
    unless current_user.projects.include?(@project)
      redirect_to @project, :notice => t('c.projects.already_disjoined')
    else
      @project.users.delete(current_user)
      redirect_to @project, :notice => t('c.projects.disjoined')
    end
  end

  def new
  end

  def edit
  end

  def create
    @project.owner = current_user

    if @project.save
      redirect_to(@project, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to(@project, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @project.destroy

    redirect_to(projects_url)
  end
end
