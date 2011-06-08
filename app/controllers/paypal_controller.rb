class PaypalController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_admin!
  include ActiveMerchant::Billing::Integrations
  
  def ipn
    # require 'ruby-debug'
    # debugger
    notify = Paypal::Notification.new(request.raw_post)
    @transaction = Transaction.new
    @transaction.status = "NEED_TO_MAP"
    @transaction.transaction_reference = params[:txn_id]
    @transaction.transaction_date = Time.now 
    @transaction.ipn_data = params
    @transaction.paypal_account_id = params[:payer_email]
    @transaction.transaction_type = params[:txn_type]
    @transaction.amount = params[:mc_gross]
    if notify.acknowledge
      @transaction.save
    else
      @transaction.save(false)
    end
    
    render :nothing => true
  end
  
end