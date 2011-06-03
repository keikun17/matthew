class AddAmountToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :amount, :float
  end

  def self.down
    remove_column :transactions, :amount
  end
end
