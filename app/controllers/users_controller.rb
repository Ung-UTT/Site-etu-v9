# encoding: utf-8
class UsersController < ApplicationController
  load_and_authorize_resource

  before_filter :search_and_paginate, only: :index
  before_filter :decorate, only: [:index, :show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def edit
    render_edit @user
  end

  def update
    params.delete(:login) # cannot update his login

    if @user.update_without_password(params[:user])
      redirect_to(@user, notice: t('c.updated'))
    else
      render_edit @user
    end
  end
end
