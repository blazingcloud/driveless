class AddGreenMilesColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :green_miles, :integer, :default => 0
  end

  def self.down
    remove_column :users, :green_miles
  end
end
