class AddOwnerInGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :owner_id, :integer, :null => false
  end

  def self.down
    remove_column :groups, :owner_id
  end
end
