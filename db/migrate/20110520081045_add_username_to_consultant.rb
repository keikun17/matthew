class AddUsernameToConsultant < ActiveRecord::Migration
  def self.up
    add_column :consultants, :username, :string
  end

  def self.down
    remove_column :consultants, :username
  end
end
