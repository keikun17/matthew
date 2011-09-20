#This table holds all devex users that are linked with Matthew
class DevexUser < ActiveRecord::Base
  has_many :paypal_accounts
  has_many :transactions, :through => :paypal_accounts

  after_save :upload_transactions_to_quickbooks

  cattr_reader :per_page
  @@per_page = 20
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
  def upload_transactions_to_quickbooks
    self.transactions.each do |transaction|
      transaction.upload_to_quickbooks
    end
  end
  
end
