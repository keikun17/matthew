class CreateDevexUsers < ActiveRecord::Migration
  def self.up
    create_table :devex_users do |t|
      t.string :username
      t.integer :account_id
      t.string :account_type
      t.string :first_name
      t.string :last_name
      t.integer :qb_id
      t.string :qb_member_name
      t.timestamps
    end
  end

  def self.down
    drop_table :devex_users
  end
end
