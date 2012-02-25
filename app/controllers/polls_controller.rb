# encoding: utf-8
class PollsController < ApplicationController
  load_and_authorize_resource

  # GET /polls
  # GET /polls.json
  def index
    @polls = Poll.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @polls }
    end
  end

  # GET /polls/1
  # GET /polls/1.json
  def show
    @poll = Poll.find(params[:id])
    @vote = @poll.voted_by?(current_user) ? @poll.vote_of(current_user) : nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @poll }
    end
  end

  # GET /polls/new
  # GET /polls/new.json
  def new
    @poll = Poll.new
    5.times { @poll.answers.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @poll }
    end
  end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])

    @poll.answers.build

    if @poll.answers.size < 5
      (5 - @poll.answers.size).times { @poll.answers.build }
    end
  end

  # POST /polls
  # POST /polls.json
  def create
    @poll = Poll.new(params[:poll])
    @poll.user = current_user

    respond_to do |format|
      if @poll.save
        format.html { redirect_to @poll, :notice => t('c.polls.create') }
        format.json { render :json => @poll, :status => :created, :location => @poll }
      else
        format.html { render :action => "new" }
        format.json { render :json => @poll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /polls/1
  # PUT /polls/1.json
  def update
    @poll = Poll.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        format.html { redirect_to @poll, :notice => t('c.polls.update') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @poll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to polls_url }
      format.json { head :ok }
    end
  end
end
