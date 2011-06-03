class DeleteThisLater < ActiveRecord::Migration
  def self.up
    create_table :consultants do |t|
      t.string :first_name
      t.string :last_name
      t.integer :service_level_id
    end
  end

  def self.down
    
  end
end
