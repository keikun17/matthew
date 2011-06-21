#transaciton types
#- adjustment
#- recurring_payment
#- send_money
#- web_accept

seeds = ["10001","10002","10003","10004","10005","10006","10007","10008"]
amounts = [100.00, 200.00, 140.00, 14.00]
names = ["alodia", "gosengfiao", "lim", "haley", "melissa", "sasha", "stoya", "erik", "cassandra", "princess", "may", "april", "jun"]
seeds.each do |seed|
  fake_name = names.sort_by{rand}[0..1]
  amount = amounts.sort_by{rand}[0]
  Transaction.create(
    :payer_email => "#{fake_name.join}@testemail.com",
    :payer_id => "payer_id_#{seed}",
    :transaction_reference => "txn_id_#{seed}",
    :transaction_type => "web_accept",
    :ipn_data => {
      :payer_email => "#{fake_name.join}@testemail.com",
      :txn_id => "txn_id_#{seed}",
      :txn_type => "web_accept",
      :payer_id => "payer_id_#{seed}",
      :last_name => fake_name[0],
      :first_name => fake_name[1]},
    :amount => amount,
    :transaction_reference => "txn_id_#{seed}",
    :transaction_date => Time.now.to_s(:db))
end


names = ["erik", "kami", "nico", "mariel", "freida", "flerida", "zyra", "joshua", "eumir", "carlo"]
5.times do
  fake_name = names.sort_by{rand}[0..1]
  fake_email = fake_name.join + "@devex.com"
  Consultant.create(
    :first_name => fake_name[0],
    :last_name => fake_name[1],
    :service_level_id => 1,
    :username => fake_email)
end





=> {"test_ipn"=>"1", "payment_type"=>"instant", "payment_date"=>"02:01:54 Jun 03, 2011 PDT", "payment_status"=>"Completed", "address_status"=>"confirmed", "payer_status"=>"verified", "first_name"=>"erikus", "last_name"=>"surias", "payer_email"=>"erikus@devex.com", "payer_id"=>"TESTBUYERID01", "address_name"=>"John Smith", "address_country"=>"United States", "address_country_code"=>"US", "address_zip"=>"95131", "address_state"=>"CA", "address_city"=>"San Jose", "address_street"=>"123, any street", "business"=>"seller@paypalsandbox.com", "receiver_email"=>"seller@paypalsandbox.com", "receiver_id"=>"TESTSELLERID1", "residence_country"=>"US", "item_name"=>"something", "item_number"=>"AK-1234", "quantity"=>"1", "shipping"=>"3.04", "tax"=>"2.02", "mc_currency"=>"USD", "mc_fee"=>"0.44", "mc_gross"=>"12.34", "mc_gross_1"=>"9.34", "txn_type"=>"web_accept", "txn_id"=>"546391", "notify_version"=>"2.1", "custom"=>"xyz123", "charset"=>"windows-1252", "verify_sign"=>"Ai1PaghZh5FmBLCDCTQpwG8jB264AgL5AYX0jtSrmPv-PV.kRjiC1nJr", "controller"=>"paypal", "action"=>"ipn"} 
ruby-1.9.2-p180 :002 > Transaction.last.ipn_data.keys
 => ["test_ipn", "payment_type", "payment_date", "payment_status", "address_status", "payer_status", "first_name", "last_name", "payer_email", "payer_id", "address_name", "address_country", "address_country_code", "address_zip", "address_state", "address_city", "address_street", "business", "receiver_email", "receiver_id", "residence_country", "item_name", "item_number", "quantity", "shipping", "tax", "mc_currency", "mc_fee", "mc_gross", "mc_gross_1", "txn_type", "txn_id", "notify_version", "custom", "charset", "verify_sign", "controller", "action"]

 "test_ipn",
  "payment_type",
  "payment_date",
  "payment_status",
  "address_status",
  "payer_status",
  "first_name",
  "last_name",
  "payer_email",
  "payer_id",
  "address_name",
  "address_country",
  "address_country_code",
  "address_zip",
  "address_state",
  "address_city",
  "address_street",
  "business",
  "receiver_email",
  "receiver_id",
  "residence_country",
  "item_name",
  "item_number",
  "quantity",
  "shipping",
  "tax",
  "mc_currency",
  "mc_fee",
  "mc_gross",
  "mc_gross_1",
  "txn_type",
  "txn_id",
  "notify_version",
  "custom",
  "charset",
  "verify_sign",
  "controller",
  "action" 