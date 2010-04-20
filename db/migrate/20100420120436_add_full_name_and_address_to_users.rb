class AddFullNameAndAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string, :null => false
    add_column :users, :address, :string, :null => false
  end

  def self.down
    drop_column :users, :name
    drop_column :users, :address
  end
end
