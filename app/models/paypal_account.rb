class PaypalAccount < ActiveRecord::Base
  has_many   :transactions
  belongs_to :devex_user
  validates_presence_of :first_name, :last_name, :email
  
  scope :orphans, :conditions => "devex_user_id is null"
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
end
