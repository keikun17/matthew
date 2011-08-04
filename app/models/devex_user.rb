#This table holds all devex users that are linked with Matthew
class DevexUser < ActiveRecord::Base
  has_many :paypal_accounts
  has_many :transactions, :through => :paypal_accounts
  
  cattr_reader :per_page
  @@per_page = 20
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
end
