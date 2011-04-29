class EventsController < ApplicationController
  load_and_authorize_resource

  # GET /events
  # GET /events.xml
  def index
    @events = Event.order('date desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

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
      redirect_to @event, :notice => 'Vous participez déjà à cet événement'
    else
      @event.users << current_user
      @event.save
      redirect_to @event, :notice => 'Vous participez désormais à cet événement'
    end    
  end

  # PUT /events/1/disjoin
  # PUT /events/1/disjoin.xml
  def disjoin
    @event = Event.find(params[:id])
    
    @event.users.delete(current_user)
    @event.save
    
    redirect_to @event, :notice => 'Vous ne participez plus à cet événement'
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
    @event.organizer_id = current_user.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
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

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
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
