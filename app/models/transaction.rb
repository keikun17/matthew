class Transaction < ActiveRecord::Base
  serialize :ipn_data, Hash
  belongs_to :paypal_account
  before_validation :find_or_create_paypal_account
  validates_associated :paypal_account
  validates_presence_of :ipn_data, :transaction_reference

  
  def ipn_account_email 
    self.ipn_data[:payer_email] || self.ipn_data[:sender_email]
  end
  
  # for non-payment transactions, the ipn_account_id is expected to be nil
  def find_or_create_paypal_account
    unless self.ipn_data.nil? or !paypal_account.nil? or ipn_account_email.empty?
      self.build_paypal_account(:email => self.payer_email,
        :payer_id => self.payer_id,
        :first_name => self.ipn_data[:first_name],
        :last_name => self.ipn_data[:last_name])
    end 
  end
end

