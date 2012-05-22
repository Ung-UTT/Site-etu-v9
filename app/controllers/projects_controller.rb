# encoding: utf-8
class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_first_users, only: [:new, :edit]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end

  def show
    @comments = @project.comments
    @documents = @project.documents

    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  def new
    @project.users << current_user

    render_new projects_path
  end

  def edit
    render_edit @project
  end

  def create
    @project.users = params[:users] ? User.find(params[:users]) : []

    if @project.save
      redirect_to(@project, notice: t('c.created'))
    else
      render_edit @project
    end
  end

  def update
    @project.users = params[:users] ? User.find(params[:users]) : []

    if @project.update_attributes(params[:project])
      redirect_to(@project, notice: t('c.updated'))
    else
      render_edit @project
    end
  end

  def destroy
    @project.destroy

    redirect_to(projects_url)
  end
end
