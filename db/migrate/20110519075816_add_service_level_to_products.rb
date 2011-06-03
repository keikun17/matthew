class AddServiceLevelToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :service_level_id, :integer
  end

  def self.down
    remove_column :products, :service_level_id
  end
end
