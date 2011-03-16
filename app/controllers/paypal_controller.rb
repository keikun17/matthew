class PaypalController < ApplicationController
  
  # skip_before_filter :verify_authenticity_token
  include ActiveMerchant::Billing::Integrations
  
  def ipn
    # require 'ruby-debug'
    # debugger
    notify = Paypal::Notification.new(request.raw_post)
    
    if notify.acknowledge
      transaction = Transaction.first
      transaction.update_attributes(:status => "Paid") if transaction
    else
      #DO SOMETHING
    end
    
    render :nothing => true
  end
  
end