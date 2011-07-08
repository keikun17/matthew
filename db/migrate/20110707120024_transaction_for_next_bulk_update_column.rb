class TransactionForNextBulkUpdateColumn < ActiveRecord::Migration
  def self.up
    add_column :transactions, :for_next_bulk_update, :boolean, :default => false
  end

  def self.down
    remove_column :transactions, :for_next_bulk_update
  end
end
