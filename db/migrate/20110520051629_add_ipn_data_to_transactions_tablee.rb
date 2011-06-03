class AddIpnDataToTransactionsTablee < ActiveRecord::Migration
  def self.up
    add_column :transactions, :ipn_data, :text
  end

  def self.down
    remove_column :transactions, :ipn_data
  end
end
