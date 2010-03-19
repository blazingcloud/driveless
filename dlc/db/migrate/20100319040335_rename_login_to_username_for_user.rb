class RenameLoginToUsernameForUser < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    add_column :users, :pseudonym, :string
    remove_column :users, :login
  end

  def self.down
    add_column :users, :login, :string
    remove_column :users, :pseudonym
    remove_column :users, :username
  end
end
