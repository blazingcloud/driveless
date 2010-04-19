class AllowUsersFieldsToBeNullForFacebook < ActiveRecord::Migration
  def self.up
    change_column_null :users, :email,               true
    change_column_null :users, :persistence_token,   true
    change_column_null :users, :single_access_token, true
    change_column_null :users, :perishable_token,    true
  end

  def self.down
    change_column_null :users, :email,               false
    change_column_null :users, :persistence_token,   false
    change_column_null :users, :single_access_token, false
    change_column_null :users, :perishable_token,    false
  end
end
