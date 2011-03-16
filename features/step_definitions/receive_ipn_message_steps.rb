Given /^an incoming IPN for ([0-9]+) items$/ do |num|
  @ipn_post = set_single_payment_ipn("10.00", "test", "keikun17@gmail.com", "111111111", num)
end

Given /^an incoming IPN for ([0-9]+) items that cost ([0-9]+) each$/ do |num, price|
  total = num.to_i * price.to_f
  @ipn_post = set_single_payment_ipn(total, "test", "keikun17@gmail.com", "111111111", num)
end

Then /^the notification should have ([0-9]+) items returned$/ do |num|
  notification = PayPalNotification.new(@ipn_post)
  assert_equal(num.to_i, notification.item_numbers.length)
end

Then /^the first item should be "([^\"]*)"$/ do |arg1|
  notification = PayPalNotification.new(@ipn_post)
  assert_equal(arg1, notification.item_names[0])
end

Then /^the last item should be "([^\"]*)"$/ do |arg1|
  notification = PayPalNotification.new(@ipn_post)
  assert_equal(arg1, notification.item_names.last)
end

Then /^the notification should have a gross amount of ([0-9]+)$/ do |num|
  notification = PayPalNotification.new(@ipn_post)
  assert_equal(num.to_f, notification.gross)
end

When /^an IPN comes in for that transaction$/ do
  transaction = Transaction.first
  puts transaction.attributes
  @ipn_post = set_single_payment_ipn(10.00, "test", transaction.user_id, "1", 1)
  #simulate post to controller
  post "/ipn", @ipn_post
  puts Transaction.first.attributes  
end

def set_single_payment_ipn(price, slug, user, tx, cart_count)
  ipn={"mc_gross" => price,
    "protection_eligibility" => "Eligible",
    "address_status" => "confirmed",
    "payer_id" => "000000000000",
    "tax" => "0.00",
    "address_street" => "1 Nowhere",
    "payment_date" => "12:00:00 Feb 19, 2011 PST",
    "payment_status" => "Completed",
    "charset" => "windows-1252",
    "address-zip" => "97863",
    "mc_shipping" => "0.00",
    "mc_handline" => "0.00",
    "first_name" => "Buddy",
    "last_name" => "Magsipoc",
    "mc_fee" => "100.00",    
    "address_country_code" => "USD",
    "address_name" => "something here",
    "notify_version" => "2.9",
    "residence_country" => "US",
    "receipt_id" => "1111-2222-3333-44444",
    "transaction_subject" => "000000000000000",
    "test_ipn" => "1",
    "payment_gross" => price,
    "num_cart_items" => cart_count.to_i
    }
    
    items = Hash.new
    item_count = cart_count.to_i
    (1..item_count).each do |item|
      items["item_number#{item}"]= slug
      items["item_name#{item}"]= "Item #{item}"
    end
    
    ipn.merge!(items)
end

