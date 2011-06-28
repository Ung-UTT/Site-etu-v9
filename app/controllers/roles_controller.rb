class RolesController < ApplicationController
  load_and_authorize_resource

  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  def join
    @role = Role.find(params[:id])
    @user = User.find(params[:role][:users])

    if @role.users.include?(@user)
      redirect_to @role, :notice => "#{@user.login} a déjà ce rôle"
    else
      @role.users << @user
      redirect_to @role, :notice => "Le rôle a été ajouté à #{@user.login}"
    end
  end

  def disjoin
    @role = Role.find(params[:id])

    # Ne peut que supprimer sa partition aux rôles (sauf si il a du pouvoir ;)
    if params[:user_id] != current_user.id and Ability.new(current_user).cannot? :destroy, @role
      raise CanCan::AccessDenied
    end

    @user = User.find(params[:user_id])
    @role.users.delete(@user)

    redirect_to @role, :notice => "Le rôle a été enlevé à #{@user.login}"
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        format.html { redirect_to(@role, :notice => 'Le rôle a été crée') }
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to(@role, :notice => 'Le rôle a été mis à jour') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end
end
