# encoding: utf-8
class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  def show
    @project = Project.find(params[:id])
    @comments = @project.comments
    @documents = @project.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  def join
    @project = Project.find(params[:id])

    if @project.users.include?(current_user)
      redirect_to @project, :notice => t('c.projects.already_join')
    else
      @project.users << current_user
      @project.save
      redirect_to @project, :notice => t('c.projects.join')
    end
  end

  def disjoin
    @project = Project.find(params[:id])

    unless current_user.projects.include?(@project)
      redirect_to @project, :notice => t('c.projects.already_disjoin')
    else
      @project.users.delete(current_user)
      redirect_to @project, :notice => t('c.projects.disjoin')
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    @project.owner = current_user

    if @project.save
      redirect_to(@project, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      redirect_to(@project, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to(projects_url)
  end
end
