# encoding: utf-8

class PollsController < ApplicationController
  load_and_authorize_resource

  before_filter :search_and_paginate, only: :index

  def index
    respond_to do |format|
      format.html
      format.json { render json: @polls }
    end
  end

  def show
    # Récupére le vote de l'utilisateur actuel
    @vote = @poll.voted_by?(current_user) ? @poll.vote_of(current_user) : nil

    respond_to do |format|
      format.html
      format.json { render json: @poll }
    end
  end

  def new
    Poll::DEFAULT_ANSWERS.times { @poll.answers.build }

    render_new polls_path
  end

  def edit
    # The user can type more answers than before (there is no limit)
    (Poll::DEFAULT_ANSWERS/2).times { @poll.answers.build }

    render_edit @poll
  end

  def create
    @poll.user = current_user

    if @poll.save
      redirect_to @poll, notice: t('c.created')
    else
      render_edit @poll
    end
  end

  def update
    if @poll.update_attributes(params[:poll])
      redirect_to @poll, notice: t('c.updated')
    else
      render_edit @poll
    end
  end

  def destroy
    @poll.destroy

    redirect_to polls_url
  end
end
