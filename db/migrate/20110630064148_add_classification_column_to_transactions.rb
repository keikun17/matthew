class AddClassificationColumnToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :classification, :string
  end

  def self.down
    remove :transactions, :classification
  end
end
