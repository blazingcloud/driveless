class AddUserIdFriendIdUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :friendships, [:user_id, :friend_id], :unique => true
  end

  def self.down
    remove_index :friendships, [:user_id, :friend_id]
  end
end
