class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.string :status
      t.integer :user_id
      t.string :user_type
      t.string :transaction_reference

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
