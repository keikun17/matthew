class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :paypal_product_code
      t.integer :devex_product_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
