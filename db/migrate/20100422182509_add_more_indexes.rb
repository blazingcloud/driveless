class AddMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :username
    remove_index :users, :email
  end
end
