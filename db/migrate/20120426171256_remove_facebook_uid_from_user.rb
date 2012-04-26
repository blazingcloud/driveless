class RemoveFacebookUidFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :facebook_uid
  end

  def self.down
    add_column :users, :facebook_uid, :string
  end
end
