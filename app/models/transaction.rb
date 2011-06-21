class Transaction < ActiveRecord::Base
  serialize :ipn_data, Hash
  belongs_to :paypal_account
  before_validation :set_or_create_paypal_account
  validates_associated :paypal_account
  validates :ipn_data, :presence => true
  validates :transaction_reference, :presence => true
  validates :paypal_account_id, :presence => true
  def ipn_account_email 
    self.payer_email
  end
  
  # for non-payment transactions, the ipn_account_id is expected to be nil
  def set_or_create_paypal_account
    self.paypal_account = PaypalAccount.find_by_email(payer_email)
    unless ipn_data.nil? or !self.paypal_account.nil? or payer_email.blank?
      pp_account = self.build_paypal_account(:email => payer_email,
        :payer_id => payer_id,
        :first_name => ipn_data["first_name"],
        :last_name => ipn_data["last_name"])
      pp_account.save        
      self.paypal_account_id = self.paypal_account.id
    end 
  end
end

