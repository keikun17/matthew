class PaypalAccount < ActiveRecord::Base
  has_many   :transactions
  belongs_to :devex_user
  validates :first_name, :last_name,:email, :presence => true

  scope :orphans, :conditions => "devex_user_id is null"

  after_create :automap_devex_account, :if => Proc.new { |paypal_account| paypal_account.devex_user.nil? and AUTO_MAP_PAYPAL_ACCOUNT_TO_QUICKBOOKS }
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
  def automap_devex_account
    user = User.find_by_username(self.email)
    if !user.nil?
      devex_user = DevexUser.new(:account_id => user.consultant.id,
        :username => user.username,
        :account_type => "Consultant",
        :first_name => user.consultant.first_name,
        :last_name => user.consultant.last_name)
      if devex_user.save
        self.update_attributes(:devex_user_id => devex_user.id)
      end
    end
  end
  
end
