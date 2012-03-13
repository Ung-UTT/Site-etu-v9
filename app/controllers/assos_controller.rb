# encoding: utf-8
class AssosController < ApplicationController
  before_filter :process_image, :only => [:create, :update]
  load_and_authorize_resource

  # GET /assos
  # GET /assos.xml
  def index
    @assos = Asso.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assos }
    end
  end

  # GET /assos/1
  # GET /assos/1.xml
  def show
    @asso = Asso.find(params[:id])
    @comments = @asso.comments
    @documents = @asso.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asso }
    end
  end

  # PUT /assos/1/join
  def join
    @asso = Asso.find(params[:id])

    if current_user.is_member_of? @asso
      redirect_to @asso, :notice => t('c.assos.already_join')
    else
      # Chaque asso a un rôle membre, une fois que l'utilisateur a ce rôle
      # il fait parti de l'asso
      current_user.roles << @asso.member
      current_user.save
      redirect_to @asso, :notice => t('c.assos.join')
    end
  end

  # PUT /assos/1/disjoin
  def disjoin
    @asso = Asso.find(params[:id])

    unless current_user.assos.include?(@asso)
      redirect_to @asso, :notice => t('c.assos.already_disjoin')
    else
      # On retire tout les rôles de l'utilisateur dans l'asso
      @asso.delete_user(current_user)
      redirect_to @asso, :notice => t('c.assos.disjoin')
    end
  end

  # GET /assos/new
  # GET /assos/new.xml
  def new
    @asso = Asso.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asso }
    end
  end

  # GET /assos/1/edit
  def edit
    @asso = Asso.find(params[:id])
  end

  # POST /assos
  # POST /assos.xml
  def create
    @asso = Asso.new(params[:asso])
    @asso.owner = current_user

    respond_to do |format|
      if @asso.save
        format.html { redirect_to(@asso, :notice => t('c.assos.create')) }
        format.xml  { render :xml => @asso, :status => :created, :location => @asso }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asso.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assos/1
  # PUT /assos/1.xml
  def update
    @asso = Asso.find(params[:id])
    puts params[:asso]

    # Si la case "supprimer" est cochée, on supprime l'image
    if params[:image_delete]
      @asso.image = nil
    end

    respond_to do |format|
      if @asso.update_attributes(params[:asso])
        format.html { redirect_to(@asso, :notice => t('c.assos.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asso.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assos/1
  # DELETE /assos/1.xml
  def destroy
    @asso = Asso.find(params[:id])
    @asso.destroy

    respond_to do |format|
      format.html { redirect_to(assos_url) }
      format.xml  { head :ok }
    end
  end

  private
    # Permet de créer l'image à partir du fichier
    def process_image
      params[:asso][:image] = Image.new(:asset => params[:asso][:image])
    end
end
