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
10.times do
  fake_name = names.sort_by{rand}[0..1]
  fake_email = fake_name.join + "@devex.com"
  Consultant.create(
    :first_name => fake_name[0],
    :last_name => fake_name[1],
    :service_level_id => 1,
    :username => fake_email)
end