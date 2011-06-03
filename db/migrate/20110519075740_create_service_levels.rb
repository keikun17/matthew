class CreateServiceLevels < ActiveRecord::Migration
  def self.up
    create_table :service_levels do |t|
      t.integer :devex_service_level_id 
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :service_levels
  end
end
