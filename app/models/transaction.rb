class Transaction < ActiveRecord::Base
  
  CREDIT_TXN_TYPES = ["adjustment"]
  
  serialize :ipn_data, Hash
  belongs_to :paypal_account
  has_one :devex_user, :through => :paypal_account
  before_validation :set_classification
  before_validation :set_or_create_paypal_account
  validates_associated :paypal_account
  after_create :upload_to_quickbooks,  :if => Proc.new { |transaction| !transaction.product.blank? }

  validates :ipn_data, :presence => true
  validates :transaction_reference, :presence => true, :uniqueness => true
  validates :paypal_account_id, :presence => true
  default_scope :order => "created_at desc"
  scope :uploadable, :conditions => ["(uploaded_to_qb is null or uploaded_to_qb = ?) and for_next_bulk_update = ?", false, false]
  scope :invoices, :conditions => {:classification => 'invoice'}
  scope :credits, :conditions => {:classification => 'credit'}
  
  scope :for_next_bulk_update, :conditions => {:for_next_bulk_update => true}
  scope :not_for_next_bulk_update, :conditions => {:for_next_bulk_update => false}

  delegate :full_name, :prefix => true, :to => :devex_user, :allow_nil => true

  self.per_page = 20
  
  def ipn_account_email 
    self.payer_email
  end
  
  def set_classification
    unless self.amount.nil?
      if credit_transaction_type? or self.amount < 0
        self.classification = 'credit'
        self.parent_transaction_id = self[:ipn_data]["parent_txn_id"]
        self.product = self.parent_transaction.product unless self.parent_transaction.nil?
      else
        self.classification = 'invoice'
      end
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
      if pp_account.save
        map_paypal_account_to_devex_account(pp_account)
      end
      self.paypal_account_id = self.paypal_account.id
    end 
  end
  
  def map_paypal_account_to_devex_account(pp_account)
    begin
      eval "@evaluated_custom = #{self.custom}"
      target_devex_user = User.find_by_username(@evaluated_custom[:devex_username])
      pp_account.automap_devex_account(target_devex_user.username)
    rescue Exception => exc
    end
  end
  
  def self.upload_batch_sales_receipt(transaction_ids)
    Qboe.upload_batch_sales_receipt(transaction_ids)
  end
  
  def self.upload_batch_credit_memo(transaction_ids)
    Qboe.upload_batch_credit_memo(transaction_ids)
  end

  
  def upload_to_quickbooks
    @product = Product.find_by_paypal_product_code(self.product)
    return false if @product.nil?
    case self.classification
    when 'invoice'
      if self.paypal_account and (self.paypal_account.devex_user or (!@product.nil? and !@product.batch_qb_name.blank?)) and ((!self.paypal_account.devex_user.nil? and !self.paypal_account.devex_user.qb_member_name.blank?) or !@product.batch_qb_name.blank?)
        items = [self.product]
        if !@product.nil? and !@product.batch_qb_name.blank?
          full_name = @product.batch_qb_name
          self.update_attribute(:for_next_bulk_update, true)
        else
          full_name = self.paypal_account.devex_user.qb_member_name
          qb_message = Qboe.create_sales_receipt(full_name, items, self.paypal_account.devex_user.username)
          self.update_attributes(:uploaded_to_qb => true)
        end
      end
    when 'credit'
      if self.paypal_account and (self.paypal_account.devex_user or (!@product.nil? and !@product.batch_qb_name.blank?)) and ((!self.paypal_account.devex_user.nil? and !self.paypal_account.devex_user.qb_member_name.blank?) or !@product.batch_qb_name.blank?)
        amount = self.amount
        items = [self.product]
        if !@product.nil? and !@product.batch_qb_name.blank?
          full_name = @product.batch_qb_name
          self.update_attribute(:for_next_bulk_update, true)
        else  
          full_name = self.paypal_account.devex_user.qb_member_name
          qb_message = Qboe.create_credit(full_name, amount, items)
          self.update_attributes(:uploaded_to_qb => true)
        end
      end      
    end
  end
  
  def parent_transaction
    Transaction.find_by_transaction_reference(self.parent_transaction_id.to_s) if !self.parent_transaction_id.nil?
  end
  
  def credit_transaction_type?
    CREDIT_TXN_TYPES.include?(self.transaction_type)
  end
  
end

