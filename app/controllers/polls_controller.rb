# encoding: utf-8
class PollsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @polls }
    end
  end

  def show
    # Récupére le vote de l'utilisateur actuel
    @vote = @poll.voted_by?(current_user) ? @poll.vote_of(current_user) : nil

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @poll }
    end
  end

  def new
    Poll::MAX_ANSWERS.times { @poll.answers.build }

    render 'layouts/_new', locals: {ressources: polls_path}
  end

  def edit
    # Au moins un formulaire de réponse
    @poll.answers.build
    if @poll.answers.size < Poll::MAX_ANSWERS
      (Poll::MAX_ANSWERS - @poll.answers.size).times { @poll.answers.build }
    end

    render 'layouts/_edit', locals: {ressource: @poll}
  end

  def create
    @poll.user = current_user

    if @poll.save
      redirect_to @poll, :notice => t('c.created')
    else
      render :action => "new"
    end
  end

  def update
    if @poll.update_attributes(params[:poll])
      redirect_to @poll, :notice => t('c.updated')
    else
      render :action => "edit"
    end
  end

  def destroy
    @poll.destroy

    redirect_to polls_url
  end
end
