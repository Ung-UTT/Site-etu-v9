# encoding: utf-8
class ProjectsController < ApplicationController
  load_and_authorize_resource

  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @comments = @project.comments
    @documents = @project.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # PUT /projects/1/join
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

  # PUT /projects/1/disjoin
  def disjoin
    @project = Project.find(params[:id])

    unless current_user.projects.include?(@project)
      redirect_to @project, :notice => t('c.projects.already_disjoin')
    else
      @project.users.delete(current_user)
      redirect_to @project, :notice => t('c.projects.disjoin')
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.owner = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => t('c.create')) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => t('c.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
