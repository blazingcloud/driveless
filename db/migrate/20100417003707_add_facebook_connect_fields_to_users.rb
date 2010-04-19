class AddFacebookConnectFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_uid, :integer, :limit => 8
    add_column :users, :facebook_session_key, :string
  end

  def self.down
    remove_column :users, :facebook_session_key
    remove_column :users, :facebook_uid
  end
end
