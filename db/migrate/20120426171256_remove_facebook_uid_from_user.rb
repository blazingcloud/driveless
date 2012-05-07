class RemoveFacebookUidFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :facebook_uid
    remove_column :users, :facebook_session_key
  end

  def self.down
    add_column :users, :facebook_uid, :string
    add_column :users, :facebook_session_key,:string
  end
end
