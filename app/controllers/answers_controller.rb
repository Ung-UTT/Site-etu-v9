# encoding: utf-8
class AnswersController < ApplicationController
  load_and_authorize_resource

  def create
    if @answer.save
      redirect_to @answer.poll, notice: t('c.created')
    else
      render_edit @answer
    end
  end

  def destroy
    @answer.destroy

    redirect_to @answer.poll
  end
end
