class AddTransactionDateToTransactionsTable < ActiveRecord::Migration
  def self.up
    add_column :transactions, :transaction_date, :datetime
  end

  def self.down
    remove_column :transactions, :transaction_date
  end
end
