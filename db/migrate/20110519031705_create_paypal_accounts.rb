class CreatePaypalAccounts < ActiveRecord::Migration
  def self.up
    create_table :paypal_accounts do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.belongs_to :devex_user
      t.timestamps
    end
  end

  def self.down
    drop_table :paypal_accounts
  end
end
