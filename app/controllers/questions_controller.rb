class QuestionsController < ApplicationController
  load_and_authorize_resource

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question.pool, :notice => t('c.questions.create') }
        format.json { render :json => @question, :status => :created, :location => @question.pool }
      else
        format.html { render :action => "new" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to @question.pool }
      format.json { head :ok }
    end
  end
end
