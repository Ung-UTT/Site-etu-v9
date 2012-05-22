# encoding: utf-8
class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @events = @events.page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    @comments = @event.comments
    @documents = @event.documents
    @news = @event.news.page(params[:page]) # Les daymails associés

    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  def join
    if @event.users.exists?(current_user)
      redirect_to @event, notice: t('c.events.already_joined')
    else
      @event.users << current_user
      @event.save
      redirect_to @event, notice: t('c.events.joined')
    end
  end

  def disjoin
    @event.users.delete(current_user)
    @event.save

    redirect_to @event, notice: t('c.events.disjoined')
  end

  def new
    render_new events_path
  end

  def edit
    render_edit @event
  end

  def create
    @event.owner = current_user
    @event.assos = params[:assos] ? Asso.find(params[:assos]) : []

    if @event.save
      redirect_to(@event, notice: t('c.created'))
    else
      render_edit @event
    end
  end

  def update
    @event.assos = params[:assos] ? Asso.find(params[:assos]) : []

    if @event.update_attributes(params[:event])
      redirect_to(@event, notice: t('c.updated'))
    else
      render_edit @event
    end
  end

  def destroy
    @event.destroy

    redirect_to(events_url)
  end
end
