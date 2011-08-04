class PaypalAccountsController < ApplicationController
  # GET /paypal_accounts
  # GET /paypal_accounts.xml
  def index
    if params[:devex_user_id]
      @devex_user = DevexUser.find params[:devex_user_id]
      @paypal_accounts = @devex_user.paypal_accounts
    else
      @paypal_accounts = PaypalAccount.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paypal_accounts }
    end
  end
  
  def orphans
    @paypal_accounts = PaypalAccount.find(:all, :conditions => "devex_user_id is null")
  end

  # GET /paypal_accounts/1
  # GET /paypal_accounts/1.xml
  def show
    @paypal_account = PaypalAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paypal_account }
    end
  end

  # GET /paypal_accounts/new
  # GET /paypal_accounts/new.xml
  def new
    @paypal_account = PaypalAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paypal_account }
    end
  end

  # GET /paypal_accounts/1/edit
  def edit
    @paypal_account = PaypalAccount.find(params[:id])
  end

  # POST /paypal_accounts
  # POST /paypal_accounts.xml
  def create
    @paypal_account = PaypalAccount.new(params[:paypal_account])

    respond_to do |format|
      if @paypal_account.save
        format.html { redirect_to(@paypal_account, :notice => 'Paypal account was successfully created.') }
        format.xml  { render :xml => @paypal_account, :status => :created, :location => @paypal_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paypal_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /paypal_accounts/1
  # PUT /paypal_accounts/1.xml
  def update
    @paypal_account = PaypalAccount.find(params[:id])

    respond_to do |format|
      if @paypal_account.update_attributes(params[:paypal_account])
        format.html { redirect_to(@paypal_account, :notice => 'Paypal account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paypal_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /paypal_accounts/1
  # DELETE /paypal_accounts/1.xml
  def destroy
    @paypal_account = PaypalAccount.find(params[:id])
    @paypal_account.destroy

    respond_to do |format|
      format.html { redirect_to(paypal_accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def map
    @consultants = []
    @paypal_account = PaypalAccount.find(params[:id])
  end
    
end
