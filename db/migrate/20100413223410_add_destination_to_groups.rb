class AddDestinationToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :destination_id, :integer, :null => false, :default => -1
  end

  def self.down
    remove_column :groups, :destination_id
  end
end
