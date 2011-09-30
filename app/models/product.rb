class Product < ActiveRecord::Base
  belongs_to :service_level

  def transactions
    Transaction.find(:all, :conditions => "product = '#{self.paypal_product_code}'")
  end

  def self.batch_names
    Product.find(:all, :select => "distinct batch_qb_name", :conditions => "batch_qb_name != '' and batch_qb_name is not null").map{|x| x.batch_qb_name}
  end
end
