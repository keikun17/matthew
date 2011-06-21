class AddQbFlagToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :uploaded_to_qb, :boolean
  end

  def self.down
    remove_column :transactions, :uploaded_to_qb
  end
end
