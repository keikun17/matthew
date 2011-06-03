class AddTransactionTypeToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :transaction_type, :string
  end

  def self.down
    remove_column :transactions, :transaction_type
  end
end
