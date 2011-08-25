class PaypalController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_admin!
  include ActiveMerchant::Billing::Integrations
  
  def ipn
    # require 'ruby-debug'
    # debugger
    notify = Paypal::Notification.new(request.raw_post)
    @transaction = Transaction.new
    # The merchant’s original transaction identification number for the payment from the buyer, against which the case was registered.
    @transaction.transaction_reference = params[:txn_id]
    
    # params[:txn_type] is the kind of transaction for which the IPN message was sent
    @transaction.transaction_type = params[:txn_type]
    # The status of the payment:
    #  Canceled_Reversal: A reversal has been canceled. For example, you won a dispute with the customer, and the funds for the transaction that was reversed have been returned to you.
    #  Completed: The payment has been completed, and the funds have been added successfully to your account balance.
    #  Created: A German ELV payment is made using Express Checkout.
    #  Denied: You denied the payment. This happens only if the payment was previously pending because of possible reasons described for the pending_reason variable or the Fraud_Management_Filters_x variable.
    #  Expired: This authorization has expired and cannot be captured.
    #  Failed: The payment has failed. This happens only if the payment was made from your customer’s bank account.
    #  Pending: The payment is pending. See pending_reason for more information.
    #  Refunded: You refunded the payment.
    #  Reversed: A payment was reversed due to a chargeback or other type of reversal. The funds have been removed from your account balance and returned to the buyer. The reason for the reversal is specified in the ReasonCode element.
    #  Processed: A payment has been accepted.
    #  Voided: This authorization has been voided.
    @transaction.status = params[:payment_status]
    
    # mc_gross Transaction fee associated with the payment. mc_gross minus mc_fee equals the amount deposited into the receiver_email account. Equivalent to payment_fee for USD payments. If this amount is negative, it signifies a refund or reversal, and either of those payment statuses can be for the full or partial amount of the original transaction fee.
    @transaction.amount = params[:mc_gross]
    
    # transaction.ipn_data holds the raw message from paypal IPN for debugging / enhancement purposes
    @transaction.ipn_data = params

    # Customer’s primary email address. Use this email to provide any credits
    @transaction.payer_email = params[:payer_email]
    # Unique customer ID
    @transaction.payer_id = params[:payer_id]

    # echeck: This payment was funded with an eCheck.
    # instant: This payment was funded with PayPal balance, credit card, or Instant Transfer.
    @transaction.payment_type = params[:payment_type]
  
    @transaction.custom = params[:custom] unless params[:custom].blank?
    @transaction.product = params[:item_name]
    if @transaction.save and notify.acknowledge
      
    else
      logger.fatal(@transaction.errors.full_messages)
    end
      render :nothing => true
  end  
end