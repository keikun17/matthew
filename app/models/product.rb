class Product < ActiveRecord::Base
  belongs_to :service_level

  def transactions
    Transaction.find(:all, :conditions => "product = '#{self.paypal_product_code}'")
  end
end
