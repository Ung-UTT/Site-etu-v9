# encoding: utf-8
class TimesheetsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:users].nil? or params[:users].empty?
      # Récupére tout les horaires
      @timesheets = Timesheet.all
    else
      # Récupére tout les horaires des utilisateurs passés en paramétres
      @timesheets = User.find(params[:users]).map(&:timesheets).flatten.uniq
    end

    # Va trier les horaires pour prendre seulement ceux du semestre actuel
    @schedule = Timesheet.make_schedule(@timesheets)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timesheets }
    end
  end

  def show
    @timesheet = Timesheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timesheet }
    end
  end

  def new
    @timesheet = Timesheet.new
  end

  def edit
    @timesheet = Timesheet.find(params[:id])
  end

  def create
    @timesheet = Timesheet.new(params[:timesheet])
    @timesheet.users = params[:users] ? User.find(params[:users]) : []

    if @timesheet.save
      redirect_to(@timesheet, :notice => t('c.create'))
    else
      render :action => "new"
    end
  end

  def update
    @timesheet = Timesheet.find(params[:id])
    @timesheet.users = params[:users] ? User.find(params[:users]) : []

    if @timesheet.update_attributes(params[:timesheet])
      redirect_to(@timesheet, :notice => t('c.update'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @timesheet = Timesheet.find(params[:id])
    @timesheet.destroy

    redirect_to(timesheets_url)
  end
end
