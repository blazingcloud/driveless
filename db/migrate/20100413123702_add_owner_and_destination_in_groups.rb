class AddOwnerAndDestinationInGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :user_id, :integer, :null => false
    add_column :groups, :destination_id, :integer, :null => false
  end

  def self.down
    remove_column :groups, :user_id
    remove_column :groups, :destination_id
  end
end
