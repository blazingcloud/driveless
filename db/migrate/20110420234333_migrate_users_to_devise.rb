class MigrateUsersToDevise < ActiveRecord::Migration

  def self.up
    
    #:database_authenticatable
    #apply_devise_schema :email,              String, :null => null, :default => default if include_email
    #apply_devise_schema :encrypted_password, String, :null => null, :default => default, :limit => 128
    rename_column :users, :crypted_password, :encrypted_password

    #:recoverable
    #apply_devise_schema :reset_password_token, String
    #apply_devise_schema :reset_password_sent_at, DateTime if use_within
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :timestamp

    #:rememberable
    #apply_devise_schema :remember_token,      String unless use_salt
    #apply_devise_schema :remember_created_at, DateTime
    add_column :users, :remember_token, :string
    add_column :users, :remember_created_at, :datetime

    #:trackable
    #apply_devise_schema :sign_in_count,      Integer, :default => 0
    #apply_devise_schema :current_sign_in_at, DateTime
    #apply_devise_schema :last_sign_in_at,    DateTime
    #apply_devise_schema :current_sign_in_ip, String
    #apply_devise_schema :last_sign_in_ip,    String
    add_column :users, :sign_in_count, :integer, :default => 0
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

    #:token_authenticatable
    #apply_devise_schema :authentication_token, String
    add_column :users, :authentication_token, :string

    # Remove unused authlogic columns
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
    remove_column :users, :reset_password_sent_at
    

    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
  end

end
