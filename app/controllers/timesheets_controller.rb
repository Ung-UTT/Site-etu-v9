# encoding: utf-8
class TimesheetsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_first_users, only: [:index, :new, :edit, :create]

  def index
    if params[:users].blank?
      # Récupére aucun horaire
      @timesheets = []
      @users = []
    else
      # Récupére tous les horaires des utilisateurs passés en paramétres
      @users = User.find(params[:users])
      @timesheets = @users.map(&:timesheets).flatten.uniq
    end

    # Va trier les horaires pour prendre seulement ceux du semestre actuel
    @schedule = Timesheet.make_schedule(@timesheets)

    respond_to do |format|
      format.html
      format.json { render json: @timesheets }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @timesheet }
    end
  end

  def new
    render_new timesheets_path
  end

  def edit
    render_edit @timesheet
  end

  def create
    @timesheet.users = params[:users] ? User.find(params[:users]) : []

    if @timesheet.save
      redirect_to(@timesheet, notice: t('c.created'))
    else
      render_edit @timesheet
    end
  end

  def update
    @timesheet.users = params[:users] ? User.find(params[:users]) : []

    if @timesheet.update_attributes(params[:timesheet])
      redirect_to(@timesheet, notice: t('c.updated'))
    else
      render_edit @timesheet
    end
  end

  def destroy
    @timesheet.destroy

    redirect_to(timesheets_url)
  end
end
