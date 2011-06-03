class DevexUsersController < ApplicationController
  # GET /devex_users
  # GET /devex_users.xml
  def index
    @devex_users = DevexUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @devex_users }
    end
  end

  # GET /devex_users/1
  # GET /devex_users/1.xml
  def show
    @devex_user = DevexUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @devex_user }
    end
  end

  # GET /devex_users/new
  # GET /devex_users/new.xml
  def new
    @devex_user = DevexUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @devex_user }
    end
  end

  # GET /devex_users/1/edit
  def edit
    @devex_user = DevexUser.find(params[:id])
  end

  # POST /devex_users
  # POST /devex_users.xml
  def create
    @devex_user = DevexUser.new(params[:devex_user])

    respond_to do |format|
      if @devex_user.save
        format.html { redirect_to(@devex_user, :notice => 'Devex user was successfully created.') }
        format.xml  { render :xml => @devex_user, :status => :created, :location => @devex_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @devex_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /devex_users/1
  # PUT /devex_users/1.xml
  def update
    @devex_user = DevexUser.find(params[:id])

    respond_to do |format|
      if @devex_user.update_attributes(params[:devex_user])
        format.html { redirect_to(@devex_user, :notice => 'Devex user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @devex_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /devex_users/1
  # DELETE /devex_users/1.xml
  def destroy
    @devex_user = DevexUser.find(params[:id])
    @devex_user.destroy

    respond_to do |format|
      format.html { redirect_to(devex_users_url) }
      format.xml  { head :ok }
    end
  end
end
