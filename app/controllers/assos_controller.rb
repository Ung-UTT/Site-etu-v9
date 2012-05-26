# encoding: utf-8
class AssosController < ApplicationController
  before_filter :process_image, only: [:create, :update]
  load_and_authorize_resource

  def index
    @assos = search_and_paginate(@assos)

    respond_to do |format|
      format.html
      format.json { render json: @assos }
    end
  end

  def show
    @comments = @asso.comments
    @documents = @asso.documents
    @joinable_roles = @asso.joinable_roles(current_user)
    @disjoinable_roles = @asso.disjoinable_roles(current_user)

    respond_to do |format|
      format.html
      format.json { render json: @asso }
    end
  end

  def join
    role = params[:asso][:roles]
    if @asso.has_user? current_user, role
      redirect_to @asso, notice: t('c.assos.already_joined', role: t("model.role.roles.#{role}", default: role))
    else
      @asso.add_user current_user, role
      redirect_to @asso, notice: t('c.assos.joined', role: t("model.role.roles.#{role}", default: role))
    end
  end

  def disjoin
    role = params[:asso][:roles]
    unless @asso.has_user? current_user, role
      redirect_to @asso, notice: t('c.assos.already_disjoined', role: t("model.role.roles.#{role}", default: role))
    else
      @asso.remove_user current_user, role
      redirect_to @asso, notice: t('c.assos.disjoined', role: t("model.role.roles.#{role}", default: role))
    end
  end

  def new
    render_new assos_path
  end

  def edit
    render_edit @asso
  end

  def create
    @asso.owner = current_user

    if @asso.save
      redirect_to(@asso, notice: t('c.created'))
    else
      render_edit @asso
    end
  end

  def update
    # Si la case "supprimer" est cochée, on supprime l'image
    if params[:image_delete]
      @asso.image = nil
    end

    if @asso.update_attributes(params[:asso])
      redirect_to(@asso, notice: t('c.updated'))
    else
      render_edit @asso
    end
  end

  def destroy
    @asso.destroy

    redirect_to(assos_url)
  end

  private
  # Permet de créer l'image à partir du fichier
  def process_image
    params[:asso][:image] = Image.new(asset: params[:asso][:image])
  end
end
