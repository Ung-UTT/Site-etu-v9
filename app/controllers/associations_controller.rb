class AssociationsController < ApplicationController
  load_and_authorize_resource

  # GET /associations
  # GET /associations.xml
  def index
    @associations = Association.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @associations }
    end
  end

  # GET /associations/1
  # GET /associations/1.xml
  def show
    @association = Association.find(params[:id])
    @comments = @association.comments
    @documents = @association.documents

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @association }
    end
  end

  # PUT /associations/1/join
  def join
    @association = Association.find(params[:id])

    if current_user.is_member_of? @association
      redirect_to @association, :notice => t('c.associations.already_join')
    else
      current_user.roles << @association.member
      current_user.save
      redirect_to @association, :notice => t('c.associations.join')
    end
  end

  # PUT /associations/1/disjoin
  def disjoin
    @association = Association.find(params[:id])

    unless current_user.associations.include?(@association)
      redirect_to @association, :notice => t('c.associations.already_disjoin')
    else
      @association.delete_user(current_user)
      redirect_to @association, :notice => t('c.associations.disjoin')
    end
  end

  # GET /associations/new
  # GET /associations/new.xml
  def new
    @association = Association.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @association }
    end
  end

  # GET /associations/1/edit
  def edit
    @association = Association.find(params[:id])
  end

  # POST /associations
  # POST /associations.xml
  def create
    @association = Association.new(params[:association])
    params[:association][:image] = Image.new(:asset => params[:association][:image])
    @association.owner = current_user

    respond_to do |format|
      if @association.save
        format.html { redirect_to(@association, :notice => t('c.associations.create')) }
        format.xml  { render :xml => @association, :status => :created, :location => @association }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /associations/1
  # PUT /associations/1.xml
  def update
    @association = Association.find(params[:id])
    if params[:association][:image].nil?
      params[:association][:image] = @association.image 
    else
      params[:association][:image] = Image.new(:asset => params[:association][:image])
    end

    respond_to do |format|
      if @association.update_attributes(params[:association])
        format.html { redirect_to(@association, :notice => t('c.associations.update')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /associations/1
  # DELETE /associations/1.xml
  def destroy
    @association = Association.find(params[:id])
    @association.destroy

    respond_to do |format|
      format.html { redirect_to(associations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    def load_logo
    end
end
