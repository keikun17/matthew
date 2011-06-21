class Transaction < ActiveRecord::Base
  serialize :ipn_data, Hash
  belongs_to :paypal_account
  before_save :create_paypal_account, :if => Proc.new{|transaction| transaction.paypal_account.nil?}
  validates_associated :paypal_account
  validates :ipn_data, :presence => true
  validates :transaction_reference, :presence => true
  validates :paypal_account_id, :presence => true
  def ipn_account_email 
    self.payer_email
  end
  
  # for non-payment transactions, the ipn_account_id is expected to be nil
  def create_paypal_account
    unless ipn_data.nil? or !paypal_account.nil? or payer_email.blank?
      self.paypal_account.create(:email => payer_email,
        :payer_id => payer_id,
        :first_name => ipn_data["first_name"],
        :last_name => ipn_data["last_name"])
    end 
  end
end

