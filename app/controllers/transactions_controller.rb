class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.xml
  def index
    if params[:devex_user_id]
      @devex_user = DevexUser.find params[:devex_user_id]
      @transactions = @devex_user.transactions
    elsif params[:paypal_account_id]
      @paypal_account = PaypalAccount.find params[:paypal_account_id]
      @transactions = @paypal_account.transactions
    else
      @transactions = Transaction.all
    end
    @total_amount = @transactions.sum(:amount)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to(@transaction, :notice => 'Transaction was successfully created.') }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to(@transaction, :notice => 'Transaction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end
  
  def upload_to_qb
    @transaction = Transaction.find(params[:id])
    @transaction.upload_to_quickbooks
    if @transaction.uploaded_to_qb
      flash[:success]
    else
        if @transaction.paypal_account and @transaction.paypal_account.devex_user and !@transaction.paypal_account.devex_user.qb_member_name.blank?
          flash[:error] = "Incomplete Mapping"
        else
          flash[:error] = "Error encountered while trying to upload transaction to QB"
        end
    end
    redirect_to request.referer
  end
  
end
