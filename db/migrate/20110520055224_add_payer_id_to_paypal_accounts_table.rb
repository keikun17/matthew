class AddPayerIdToPaypalAccountsTable < ActiveRecord::Migration
  def self.up
    add_column :paypal_accounts, :payer_id, :string
  end

  def self.down
    remove_column :paypal_accounts, :payer_id
  end
end
