class AddUniqueIndexToMemberships < ActiveRecord::Migration
  def self.up
    add_index :memberships, [:user_id, :group_id], :unique => true
  end

  def self.down
    remove_index :memberships, [:user_id, :group_id]
  end
end
