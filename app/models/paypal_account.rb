class PaypalAccount < ActiveRecord::Base
  has_many   :transactions
  belongs_to :devex_user
  validates :first_name, :presence => "true"
  validates :last_name, :presence => "true"
  validates :email, :presence => "true"
  
  scope :orphans, :conditions => "devex_user_id is null"
  
  def full_name
    [first_name, last_name].join(" ")
  end
  
end
