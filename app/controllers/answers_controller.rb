# encoding: utf-8
class AnswersController < ApplicationController
  load_and_authorize_resource

  def create
    @answer = Answer.new(params[:answer])

    if @answer.save
      redirect_to @answer.poll, :notice => t('c.create')
    else
      render :action => "new"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    redirect_to @answer.poll
  end
end
