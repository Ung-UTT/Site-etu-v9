# encoding: utf-8
class VotesController < ApplicationController
  load_and_authorize_resource

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])
    @vote.user = current_user

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote.answer.pool, :notice => t('c.votes.create') }
        format.json { render :json => @vote, :status => :created, :location => @vote.answer.pool }
      else
        format.html { render :action => "new" }
        format.json { render :json => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json
  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to @vote.answer.pool }
      format.json { head :ok }
    end
  end
end
