class Transaction < ActiveRecord::Base
  
  CREDIT_TXN_TYPES = ["adjustment"]
  
  serialize :ipn_data, Hash
  belongs_to :paypal_account
  before_validation :set_classification
  before_validation :set_or_create_paypal_account
  validates_associated :paypal_account
  after_create :upload_to_quickbooks
  
  validates :ipn_data, :presence => true
  validates :transaction_reference, :presence => true
  validates :paypal_account_id, :presence => true
  scope :uploadable, :conditions => ["uploaded_to_qb is null or uploaded_to_qb = ?", false]
  scope :invoices, :conditions => {:classification => 'invoice'}
  scope :credits, :conditions => {:classification => 'credit'}
  def ipn_account_email 
    self.payer_email
  end
  
  def set_classification
    if credit_transaction_type?
      self.classification = 'credit'
      self.parent_transaction_id = self[:ipn_data]["parent_txn_id"]
      self.product = self.parent_transaction.product unless self.parent_transaction.nil?
    else
      self.classification = 'invoice'
    end
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
  
  def upload_to_quickbooks
    case self.classification
    when 'invoice'
      if self.paypal_account and self.paypal_account.devex_user and !self.paypal_account.devex_user.qb_member_name.blank?
        items = [self.product]
        full_name = self.paypal_account.devex_user.qb_member_name
        qb_message = Qboe.create_invoice(full_name, items)
        self.update_attributes(:uploaded_to_qb => true)
      end
    when 'credit'
      if self.paypal_account and self.paypal_account.devex_user and !self.paypal_account.devex_user.qb_member_name.blank?
        amount = self.amount
        items = [self.product]
        full_name = self.paypal_account.devex_user.qb_member_name
        qb_message = Qboe.create_credit(full_name, amount, items)
        self.update_attributes(:uploaded_to_qb => true)
      end      
    end
  end
  
  def parent_transaction
    Transaction.find(self.parent_transaction_id)
  end
  
  def credit_transaction_type?
    CREDIT_TXN_TYPES.include?(self.transaction_type)
  end
  
end

