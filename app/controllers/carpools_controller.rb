# encoding: utf-8
class CarpoolsController < ApplicationController
  load_and_authorize_resource

  def index
    @carpools = search_and_paginate(@carpools)

    @drivers = @carpools.select { |car| car.is_driver }
    @not_drivers = @carpools.select { |car| !car.is_driver }

    respond_to do |format|
      format.html
      format.json { render json: @carpools }
    end
  end

  def show
    @comments = @carpool.comments
    @documents = @carpool.documents

    if @carpool.is_driver
      @driver_or_passenger =  I18n.t('carpools.driver')
    else
      @driver_or_passenger = I18n.t('carpools.passenger')
    end

    respond_to do |format|
      format.html
      format.json { render json: @carpool }
    end
  end

  def new
    render_new carpools_path
  end

  def edit
    render_edit @carpool
  end

  def create
    @carpool.user = current_user

    if @carpool.save
      redirect_to(@carpool, notice: t('c.created'))
    else
      render_edit @carpool
    end
  end

  def update
    if @carpool.update_attributes(params[:carpool])
      redirect_to(@carpool, notice: t('c.updated'))
    else
      render_edit @carpool
    end
  end

  def destroy
    @carpool.destroy

    redirect_to(carpools_url)
  end
end
