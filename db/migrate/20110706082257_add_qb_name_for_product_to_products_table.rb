class AddQbNameForProductToProductsTable < ActiveRecord::Migration
  def self.up
    add_column :products, :batch_qb_name, :string
  end

  def self.down
    remove_column :products, :batch_qb_name
  end
end
