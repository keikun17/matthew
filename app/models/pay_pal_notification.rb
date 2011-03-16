require 'net/http'

class PayPalNotification

  def initialize(params)
    @ipn = params
  end
  
  def complete?
    status = "Completed"
  end
  
  def received_at
    Time.parse @ipn['payment_date']
  end
  
  def custom
    @ipn['custom']
  end
  
  def status
    @ipn['payment_status']
  end
  
  def transaction_id
    @ipn['txn_id']
  end
  
  def acknowledge
    unless ::Rails.env == "test"
      payload = @ipn
      response = ssl_post(PAYPAL_URL + '?cmd=_notify-validate', payload, 'Content-Length' => "#{payload.size}")
      raise StandardError.new("Faulty paypal result: #{response}") unless ["VERIFIED", "INVALID"].include?(response)
    else
      response = "VERIFIED"
    end
    response == "VERIFIED"
  end
  
  # What type of transaction are we dealing with?
  #  "cart" "send_money" "web_accept" are possible here.
  def type
    @ipn['txn_type']
  end

  # the money amount we received in X.2 decimal.
  def gross
    @ipn['mc_gross']
  end

  # the markup paypal charges for the transaction
  def fee
    @ipn['mc_fee']
  end

  # What currency have we been dealing with
  def currency
    @ipn['mc_currency']
  end

  def item_numbers
    indexed_value("item_number")
  end
  
  def item_names
    indexed_value("item_name")
  end
  
  def indexed_value(key)
    cart_count=@ipn['num_cart_items'].to_i
    
    items=Array.new
    (1..cart_count).each do |item|
      indexed_key="#{key}#{item}"
      items << @ipn[indexed_key] 
    end
    items
  end
  
  def item_name(index)
    @ipn["item_name#{index}"]
  end

  def item_number
    @ipn['item_number'] || @ipn['item_number1']
  end

  # This is the invoice which you passed to paypal
  def invoice
    @ipn['invoice']
  end

  # Was this a test transaction?
  def account
    @ipn['business'] || @ipn['receiver_email']
  end
  
  def raw
    @raw
  end  
  
end

