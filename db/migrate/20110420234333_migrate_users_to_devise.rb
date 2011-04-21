class MigrateUsersToDevise < ActiveRecord::Migration

  def self.up
    add_column :users, :reset_password_token, :string
    add_column :users, :remember_token, :string
    add_column :users, :remember_created_at, :datetime
    add_column :users, :authentication_token, :string

    rename_column :users, :crypted_password, :encrypted_password

    remove_column :users, :persistence_token
    remove_column :users, :single_access_token
    remove_column :users, :perishable_token
  end

  def self.down
    add_column :users, :perishable_token, :string
    add_column :users, :single_access_token, :string
    add_column :users, :persistence_token, :string

    rename_column :users, :encrypted_password, :crypted_password

    remove_column :users, :authentication_token
    remove_column :users, :remember_created_at
    remove_column :users, :remember_token
    remove_column :users, :reset_password_token
  end

end
