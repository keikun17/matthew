class RenameTransactionTableColumns < ActiveRecord::Migration
  def self.up
    remove_column :transactions, :user_id
    remove_column :transactions, :user_type
    add_column :transactions, :paypal_account_id, :integer
    
  end

  def self.down
    add_column :transactions, :user_id, :integer
    add_column :transactions, :user_type, :string
    remove_column :transactions, :paypal_account_id
  end
end
