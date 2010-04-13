class AlterUsersRelationsToCommunities < ActiveRecord::Migration
  def self.up
    add_column :users, :community_id, :integer
  end

  def self.down
    remove_column :users, :community_id
  end
end
