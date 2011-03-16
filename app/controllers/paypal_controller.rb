class PaypalController < ApplicationController
  
  def ipn
    notify = PayPalNotification.new(params)
    if notify.acknowledge
        a = Transaction.first
        a.update_attributes(:status => "Paid")
    end
    render :nothing => true
  end
  
end