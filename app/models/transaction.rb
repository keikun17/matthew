class Transaction < ActiveRecord::Base
  serialize :ipn_data, Hash
  belongs_to :paypal_account
  before_validation :find_or_create_paypal_account
  validates_associated :paypal_account
  validates_presence_of :ipn_data, :transaction_reference

  
  def ipn_account_email 
    self.payer_email
  end
  
  # for non-payment transactions, the ipn_account_id is expected to be nil
  def find_or_create_paypal_account
    unless ipn_data.nil? or paypal_account.nil? or payer_email.blank?
      self.build_paypal_account(:email => payer_email,
        :payer_id => a.payer_id,
        :first_name => a.ipn_data["first_name"],
        :last_name => a.ipn_data["last_name"])
    end 
  end
end

