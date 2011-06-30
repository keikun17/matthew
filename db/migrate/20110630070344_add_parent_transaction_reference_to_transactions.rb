class AddParentTransactionReferenceToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :parent_transaction_id, :integer
  end

  def self.down
    remove_column :transactions, :parent_transaction_id
  end
end
