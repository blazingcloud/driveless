class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :baselines, :user_id, :unique => true
    add_index :friendships, :friend_id
    add_index :groups, :destination_id
    add_index :groups, :owner_id
    add_index :invitations, :user_id
    add_index :lengths, :trip_id
    add_index :lengths, :mode_id
    add_index :lengths, :unit_id
    add_index :memberships, :group_id
    add_index :trips, :user_id
    add_index :trips, :mode_id
    add_index :trips, :destination_id
    add_index :trips, :unit_id
    add_index :users, :community_id
  end

  def self.down
    remove_index :baselines, :user_id
    remove_index :friendships, :friend_id
    remove_index :groups, :destination_id
    remove_index :groups, :owner_id
    remove_index :invitations, :user_id
    remove_index :lengths, :trip_id
    remove_index :lengths, :mode_id
    remove_index :lengths, :unit_id
    remove_index :memberships, :group_id
    remove_index :trips, :user_id
    remove_index :trips, :mode_id
    remove_index :trips, :destination_id
    remove_index :users, :unit_id
    remove_index :users, :community_id
  end
end
