class AddFullNameAndAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string, :default => ''
    add_column :users, :address, :string, :default => ''
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :address
  end
end
