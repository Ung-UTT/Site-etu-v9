# encoding: utf-8
class AnswersController < ApplicationController
  load_and_authorize_resource

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(params[:answer])

    respond_to do |format|
      if @answer.save
<<<<<<< HEAD
        format.html { redirect_to @answer.poll, :notice => t('c.answers.create') }
        format.json { render :json => @answer, :status => :created, :location => @answer.poll }
=======
        format.html { redirect_to @answer.pool, :notice => t('c.answers.create') }
        format.json { render :json => @answer, :status => :created, :location => @answer.pool }
>>>>>>> mobile
      else
        format.html { render :action => "new" }
        format.json { render :json => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
<<<<<<< HEAD
      format.html { redirect_to @answer.poll }
=======
      format.html { redirect_to @answer.pool }
>>>>>>> mobile
      format.json { head :ok }
    end
  end
end
