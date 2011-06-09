class AdditionalTransactionColumns < ActiveRecord::Migration
  def self.up
    add_column :transactions, :payer_email, :string
    add_column :transactions, :payer_id, :string
    add_column :transactions, :payment_type, :string
    add_column :transactions, :custom, :text
    add_column :transactions, :product, :text
  end

  def self.down
    remove_column :transactions, :payer_email
    remove_column :transactions, :payer_id
    remove_column :transactions, :payment_type
    remove_column :transactions, :custom
    remove_column :transactions, :product
  end
end
