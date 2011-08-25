class AddCustomFieldToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :custom, :text
  end

  def self.down
    remove_column :transactions, :custom
  end
end
