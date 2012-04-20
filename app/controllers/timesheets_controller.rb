# encoding: utf-8
class TimesheetsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:users].nil? or params[:users].empty?
      # Récupére aucun horaire
      @timesheets = []
    else
      # Récupére tous les horaires des utilisateurs passés en paramétres
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
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timesheet }
    end
  end

  def new
  end

  def edit
  end

  def create
    @timesheet.users = params[:users] ? User.find(params[:users]) : []

    if @timesheet.save
      redirect_to(@timesheet, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    @timesheet.users = params[:users] ? User.find(params[:users]) : []

    if @timesheet.update_attributes(params[:timesheet])
      redirect_to(@timesheet, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @timesheet.destroy

    redirect_to(timesheets_url)
  end
end
