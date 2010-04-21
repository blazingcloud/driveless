class AddIs13AndIsParentAndReadPrivacyAndReadPrivacyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_13, :boolean
    add_column :users, :is_parent, :boolean
    add_column :users, :read_privacy, :boolean
    add_column :users, :zip, :string
  end

  def self.down
    remove_column :users, :zip
    remove_column :users, :read_privacy
    remove_column :users, :is_parent
    remove_column :users, :is_13
  end
end
