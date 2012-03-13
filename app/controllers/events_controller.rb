# encoding: utf-8
class EventsController < ApplicationController
  load_and_authorize_resource

  # GET /events
  # GET /events.xml
  def index
    @events = Event.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    @comments = @event.comments
    @documents = @event.documents
    @news = @event.news.page(params[:page]) # Les daymails associés

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # PUT /events/1/join
  # PUT /events/1/join.xml
  def join
    @event = Event.find(params[:id])

    if @event.users.exists?(current_user)
      redirect_to @event, :notice => t('c.events.already_join')
    else
      @event.users << current_user
      @event.save
      redirect_to @event, :notice => t('c.events.join')
    end
  end

  # PUT /events/1/disjoin
  # PUT /events/1/disjoin.xml
  def disjoin
    @event = Event.find(params[:id])

    @event.users.delete(current_user)
    @event.save

    redirect_to @event, :notice => t('c.events.disjoin')
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.owner = current_user
    @event.assos = params[:assos] ? Asso.find(params[:assos]) : []

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => t('c.events.create')) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    @event.assos = params[:assos] ? Asso.find(params[:assos]) : []

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => t('c.events.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
