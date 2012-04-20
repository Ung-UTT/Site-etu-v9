# encoding: utf-8
class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @events = @events.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  def show
    @comments = @event.comments
    @documents = @event.documents
    @news = @event.news.page(params[:page]) # Les daymails associés

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def join
    if @event.users.exists?(current_user)
      redirect_to @event, :notice => t('c.events.already_join')
    else
      @event.users << current_user
      @event.save
      redirect_to @event, :notice => t('c.events.join')
    end
  end

  def disjoin
    @event.users.delete(current_user)
    @event.save

    redirect_to @event, :notice => t('c.events.disjoin')
  end

  def new
  end

  def edit
  end

  def create
    @event.owner = current_user
    @event.assos = params[:assos] ? Asso.find(params[:assos]) : []

    if @event.save
      redirect_to(@event, :notice => t('c.created'))
    else
      render :action => "new"
    end
  end

  def update
    @event.assos = params[:assos] ? Asso.find(params[:assos]) : []

    if @event.update_attributes(params[:event])
      redirect_to(@event, :notice => t('c.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy

    redirect_to(events_url)
  end
end
